Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1772CAC5AC
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 01:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C818E0002; Tue, 23 Sep 2025 21:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D018E0001; Tue, 23 Sep 2025 21:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804718E0002; Tue, 23 Sep 2025 21:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 690F28E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:08:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4EA1140664
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:08:41 +0000 (UTC)
X-FDA: 83922358842.01.03CC287
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C0011C000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:08:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cLg2VpJl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758676119; a=rsa-sha256;
	cv=none;
	b=6TCY4I0qX+1vI0uBwUllHJtpGPkYL3VENyrCuZZRPzegshXxB1TjUeeyjbBuKy7QviEIYG
	EXnWR1Wp1VJW45Mb96E7HQP7B+m7ZP0vJr11EZ0UugG4VokEMF5nXvhkxkWySYny/od2nB
	b+HzFBLxJaxMZK9N3Y/bH5jnXJnyBes=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cLg2VpJl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758676119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgXWAsFoLxpb8J4qxlIRcO1gt5wTKGjQaepQ6HGzzzE=;
	b=UV3nq16HQ5NY5W6NYEUFLDQ+aTqYzEsmn0P+s9OkRvYXQfiQzcgMhEASeCfqtyP9kziDNs
	QTcYwcELJs3bPZ0TkLWBaPe6VCCy2y+/AtFI+9yj9QM46bDbzpDEYyN9DzuPgS2i6vZyFe
	q3158Mn6kqglCA1msiaGg+TzLjZmiCE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758676119; x=1790212119;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NMr8YHsAc1qYXXZdTcENL3OIhnYEafGh+AtSGRf6TLc=;
  b=cLg2VpJlt74ifxlDkZ6jvUAFAidCvFPYeG1qJ67u//WiL1ZmBUEAMLYw
   OCFcXihrw2UV+twoR55r052L/8OPANTxG7Jil5DVMLm/L3ddrO6EideHu
   Z4ybSOJbKQTi2oSopT5Y/8Kr0NagyQeGO9eu0hsKatu5PW9JPizhNAzN8
   Mxz9jjiPhvxR9UAZv/fzk9GuDLzlL6dz+BJN8LazoG6KI3YNMh0JhefNz
   dafnHYl6oyGv1yPyE5YoMuz33zyd6pD2ARCKngXuHrGtMphytM8F2/WBj
   0HpXywkPRw9iu2HM7g+KYVNOn/1ZWPq0VWpGsJvXqtJMOCOqROF8g5bQE
   A==;
X-CSE-ConnectionGUID: C0BOgBvPQgaam/WRLCx8FA==
X-CSE-MsgGUID: 73UIo4ikTES/qCi8NJMrNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72391784"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="72391784"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:08:37 -0700
X-CSE-ConnectionGUID: fjBTYTLDSiCoIsBzqV7wMQ==
X-CSE-MsgGUID: IyKXHQQ5TJ+72htfqHKDig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="214035413"
Received: from alc-skl-a23.sh.intel.com (HELO [10.239.53.6]) ([10.239.53.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:08:35 -0700
Message-ID: <c7ac8e6f-d24c-4a13-b9a4-c5bd287e9f9f@linux.intel.com>
Date: Wed, 24 Sep 2025 08:27:39 +0800
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C0011C000B
X-Stat-Signature: 1i537dax4akmtsb1yqqopqsjb5d11bc6
X-Rspam-User: 
X-HE-Tag: 1758676118-435801
X-HE-Meta: U2FsdGVkX19Qe8XARlPA8pyJpx0SR/lrRdCPtmBFdrKLbLWEMaYTJTiNfz45YvDx5/Q9DHNk5L/izyV7z6SVNtQqIjwZCTYn/Vpx0U4E4lSOdgIgcfuTOadqGiNgdaypXpJkJQhOMZrt/TO67sMj9lkBdMzyOuAObtj2DecbU63YBc+t45gXxr14aDrhjjdYWIUhZOjBHUQiyEggyxxQFJwZ5/pmHWxhPog5flvZf22B40VnzBnHIKfLpfnGVGFbtZFSxVQD/eBY5ax5w3CTGd7F3cXYE4nRVx1xFsNhybgRMJm4NmsLepS7EKo0QcIjzACSRLaI6wKPtut6dKBHaG5Z33JywOXY4mhg01YlcZrxhfrD3z6skXWTOU9IazAYHb//T/K5i3X5wP0l7hZ0gyrS9pJ2O+AFuBzW8kgaHLUkuVxu7IV98CoUrfoPx45O6PMneYd2l1Yoz+aAUfFP7dnr+1eIDJyFru6QEUxE7/Kb0JWBoWAaeNgM0ccnmL9LH/I+CV8nQZVhIDWcTA686DXQMaS88Wcpo8E5PpqHkwSz5iUHj9mmV+x+yqnnp9hkQ23htojYyJqntmVc4Bi9nK7Wq62JaWglDXNwVbA8hRXPe+ZsmC53l+YVosRZd2r64ImceAvbgceImhtl120tR5OXyc3Nb9e3C/2IdRCN04oR9RRqe5lDLTiCcsZ8kWmZTc1BTJZZHnCFgNWe0ZRp63csguGQWGz2EZNK9waLS1yF/khG1XJRI4boQ2+dVETwnUnZmI2dwgQisGnbcX8cMPY4fX94pyHqi0IpPIGNoJlxu7ioZdiNWTNnLi/b3UqOfqHHEQPJukFsTm0abBz8IO9G/gAzqqsoubRFXOIhWH/+mYVPt7IHOmsnsdH2n/pUfpyHkvqnc8qULeDUBlf8wdcN7cny9wKMRtWy25oaeBGEQD9ywkZkIatXJsF1+5y4l4Dj9LLEDifc4TwenMi
 4BAABeKK
 GMEzntjtfO2LN6+yjJRkKlwYkKMVvE15MBdZY891oPOR43fnD5DUcmSttN+0k1PPWxLjgLYGuq+gqrX1dsF9L8MZFglhL1aeT8hlEkYzo60QtQxkutGNlx/572LGFGV8NtefUTweuTWXdb7lNwBTLEOn4brnDDb5jbGCMXktKj68qlCq7NJQSMzYkdrEhvkswzjMGBSjcMdsHtDvhKx9s+ywmrKb+j8EbPaSZ
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
> mm.git as a confirmation would be nice. 

Yes, the hotspot remains on mm.git:mm-stable branch.

   - 88.68% clone3
      - 88.68% start_thread
         - 88.68% reader_thread
            - 88.27% syscall
                 entry_SYSCALL_64_after_hwframe
                 do_syscall_64
                 ksys_readahead
                 generic_fadvise
                 force_page_cache_ra
                 page_cache_ra_unbounded
                 filemap_add_folio
                 __filemap_add_folio
                 _raw_spin_lock_irq
               - do_raw_spin_lock
                    native_queued_spin_lock_slowpath

> Also, based on the fact that the
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

This makes sense. I actually had a version using atomic operations to update
ra in my patch, but I found that ra is also updated in other paths without
synchronization, so I dropped the atomic operations before sending the patch.
Let me check what I can do for this.

Have you put your preliminary patch somewhere?

Thanks,
-Aubrey
> 
> 								Honza


