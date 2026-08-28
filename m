Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B422DC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8273C6B0088; Thu, 27 Aug 2026 22:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1026B008A; Thu, 27 Aug 2026 22:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678F06B008C; Thu, 27 Aug 2026 22:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2BE6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:49:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACB44C032F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:49:04 +0000 (UTC)
X-FDA: 85149146208.07.6E5EE31
Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 07077180006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:49:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bsk8cZSN;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.43 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787885342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCaiQm3GfEUb+Rf9iXHvuD0prLOa1qTRq71pKQUh+rc=;
	b=kb2NOBaIWXrpIHoBJtKBgbUBF0KqDZzcCj/3rsaaB0SSJPEKyYeKU6kkg6T38SQ8nFalET
	1Fue9/U9hZvzYtk5VY8tSct7r0vev78s1hKh9N8UqFSkJqUeEUGtxxoNyipAaWAljwe7Uo
	W/YGTM03rnK44jCd68AC+H6lYYy3MN0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bsk8cZSN;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.43 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787885342;
	b=2IvJtPSoqTK+28ZtnK61DdO55rpjPBJEUbYvqmyBKkErWqf/zjARSwbELeX68NVR1bbA1V
	7Qhcm3TWExM0h2wr463xug/+9v8Q70vKhW6hNg5htlLtKRdqO/Z4viIhLwzwFYBu8QKHpd
	J9Vqz3nnF08XbWwuok4OqMMZ8ZOYpQU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p2ffFFqlot4uRmrajtMu/cdM/mLnbrmiDMtUqVJBXEw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787885338; v=1; x=1788490138;
 b=Bsk8cZSNpVFBveAcBC8zIlR+ckUC8AJmvAYxhynoXjWNDAEyvRpJ+VGmt99TOB5ePkl5ac71
 /uZi2pZpEL1D/HLEYZXPQHb50qPJXYCeZ8sUBnbJMsaTZmAQkEMp/7q76Co6BWwCFoVC5+q7K40
 b8DQgDyjdHw3RDePSrGQ8Zf4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 646f3d9741400a38;
	Fri, 28 Aug 2026 02:48:48 +0000
X-Mizu-Trace-ID: 646f3d9741400a38
X-Migadu-Flow: FLOW_OUT
Message-ID: <51f48626-c38b-4cd6-a826-92d107ae35bb@linux.dev>
Date: Fri, 28 Aug 2026 10:48:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] make unused huge shrinker memcg aware
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <20260827155020.530e28b0afa3b43fede9aa9c@linux-foundation.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260827155020.530e28b0afa3b43fede9aa9c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oibeoodaxotwcydymmxs4sc199tt3c3d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07077180006
X-Rspam-User: 
X-HE-Tag: 1787885340-358453
X-HE-Meta: U2FsdGVkX18giL73MRj7/vT1wHjEwzILy9lOlsxAfdiDIjaNSGJ/3fXzqxxc47k+jmImmYtDlqjLBGWE4Jm6UecOgQ9ttjKHkzlqgdUi3m2aYVKklyudKcVYtrXVQp0LJj4kF9gOowiD9blrAB6eLllcpT9iNPUGk2GPCz84yjknv6AbyshYMAnsnHRATM7/LZuwEqgXelGjdBOHanEoz1T5vR0xvg8p38m5bgrJjvo6XV6+7V0HLUOzfM+yJfR1Pu0Q9EgIVZMP4t5vlODMp9L36d4efjO/q+p9D/tsxqVx9JcR9s6MZXLQP8id5cw+bHox8X1npfTAXZTb6fcGgHc+WRN3Z0WbgsElsqMpKqvSZCFY6COv6SIz0YlgOVBMvPy0rXdi6CiwXXm+Ck2yzxYZlWvai94pf6fz3sCxBTcRJkDujvA23nvG2d/nrX3MXajVTg/fxv+9C87NQclXi3Y5rH5JDoMDehtvgoQuSVE3ur5riC0oilWti4iyyPtkJqjB/MjFYUALF5ATg7+ky4ROczT1awXiNtvd+F3ycinEQAhbzU/4t4A1x+Lo8Qca2gHHP7PPwnZVdG9NqN9UwvVNayaW2mnS5s4LhwvI9kOBRZ0w19nseSFE60CJtQ1qVhgK26Ju0MLKzdvjTBq6iVe8axOzocrL8cbUx+Ovk4PWJ31qE1Qh70u1MoqgkgNp552le69jaIQQjtlrs2fA8sj+bZoTZXOpPWZ8CXOynDALczjqdRVCBffD6Myd8BtLHEPZh8CYlFZ8k/C0iKsqSKqM16WplKp95flhLCVJq9U9WSH1N1ba51az4VP5z5pa//Xaebg3J7vtFHhcf1bE4ShAEqvbAvPPxNcOyHIOMWel4hdTaPlZILS/SQqBGLF2t57zM4Izl2sH6q8MwCoWMDD5F8Wb52xKFdD6z7y6L18Bp3h/j9ElthmzqiLeD7hIytVJtORqAZg7HX9Ph2f
 +Yq6qJsa
 +Z1B3dbyHnmUgNsCcFRxd841ZUtM98ZHNm9y86sDWgB8I6hecqENlzXzGul4TYdBvkHtFigLpWtF3hAbJ0b02ZhmlfDTNWQsVJ08SJuLxYdZGSlBwx942tTNV3LclUq8f/03lwWQrflGxccTmgq+OOMrywkfFXOBN+cvl/2nPaidI469jTO84BDN4xnHOCAFX51TmXrzcSl5OAhYd3JBOJldorrmt/h+yF3Zu3TYaxwwMfPt7RSX8wq35tjIOsFjTA/guQLvd5+Mzq5QdGw7rkShzf7Y33wGsABux567eXPgnZMAL98CDvLjA8cOD59LQ8nF6Boe2Uy3blXTD+pgZyGgLxHNzsmkODc62pR/B8CzQ+Y4HfRP61UWGJQok0tpgCYCD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 8/28/26 6:50 AM, Andrew Morton wrote:
> On Mon, 17 Aug 2026 17:03:24 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> Changes in v4:
>> Changes in v3:
>> Changes in v2:
> 
> Thanks for the diligent versioning info.  fyi, it is conventional to
> maintain this below the --- separator.  It's not really the most
> important part of the [0/N]!

Got it.

> 
>>
>> The shmem unused huge shrinker maintains a per-superblock list of inodes
>> whose tail huge folio extends beyond i_size.  Because this list is not
>> memcg aware, reclaim triggered by memcg A can scan inodes across the
>> entire superblock and split huge folios charged to unrelated memcg B,
>> causing unexpected impact on it.
>>
>> In the worst case, memcg A has no reclaimable shmem at all, making the
>> reclaim entirely useless and incurring unnecessary latency.  We observed
>> this in production, where page lock contention during split caused
>> multi-hundred-millisecond stalls:
> 
> Ugh.  That's the most important part!
> 
>>    tid 11340 comm scanner locked a page for 182264 us! kstack:
>>            unlock_page+1
>>            split_huge_page_to_list+3135
>>            shmem_unused_huge_shrink+767
>>            super_cache_scan+329
>>            do_shrink_slab+291
>>            shrink_slab+533
>>            shrink_node+400
>>            do_try_to_free_pages+206
>>            try_to_free_mem_cgroup_pages+262
>>            try_charge_memcg+591
>>            mem_cgroup_charge+136
>>            __handle_mm_fault+2431
>>            handle_mm_fault+194
>>            do_user_addr_fault+462
>>            __do_page_fault+176
>>            do_page_fault+48
>>            page_fault+62
>>
>> Usama's recent patch [1] prevents the shmem unused shrinker from being
>> invoked during memcg-level reclaim altogether, but this is overly
>> conservative: we can do better by reclaiming only the shmem charged to
>> the reclaiming memcg.
>>
>> This series converts the shrinker list to a memcg-aware list_lru, so
>> that non-root memcg reclaim walks only candidates charged to the
>> reclaiming memcg.  Global reclaim, root memcg reclaim and shmem quota
>> reclaim retain their existing global semantics.
>>
>> To avoid pinning a dying memcg through a long-lived CSS reference, each
>> inode stores an obj_cgroup reference instead of a mem_cgroup reference.
>> The list_lru add/delete paths resolve the current memcg from the objcg
>> under RCU, staying consistent with list_lru's own memcg migration on
>> offline.
> 
> Sashiko said a few things and they look disturbing-if-true:
> 
> 	https://sashiko.dev/#/patchset/cover.1786955972.git.zhengqi.arch@bytedance.com
> 
> (Apologies if this has already been considered - we don't have ways of
> tracking all this (yet, I hope) apart from personal memory and personal
> memorys are quite fried at present)

As both Usama and I have pointed out [1][2], [PATCH v4 1/4] is the part
that got dropped during the merge. The complete patch [3] was actually
reviewed a while ago.

[1].https://lore.kernel.org/all/20260810101954.822260-1-usama.arif@linux.dev/
[2]. 
https://lore.kernel.org/all/9c7efd5f-f8d3-4926-acb4-34c326ffb1c3@linux.dev/
[3]. 
https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/

Thanks,
Qi

> 


