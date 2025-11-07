Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA9ECCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14DE8E000A; Thu,  6 Nov 2025 21:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4658E0002; Thu,  6 Nov 2025 21:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B46A8E000A; Thu,  6 Nov 2025 21:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88AFB8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:52:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3673D86B13
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:52:25 +0000 (UTC)
X-FDA: 84082287450.27.D1AECC5
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E2BE1C0007
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:52:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R4sjC/6n";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762483943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52V3X2Sr5dWVePWtrbdXKFUg9bUNSzwTF2IQfUlVk1g=;
	b=rckxtQTGO0H8Hb3zu3Uuda4B0/i2HPwxYf2IYH3n+mCO5h9c2fMy5/UObYuGWnqO08QijE
	hmaeQBFScehcplPE6xfSmlj4mwHx26EZ0ttiCVWOobeEzaY01VxkZ4i7kIMbUfkDli0H0Y
	Agr7Wk0jSOG/GPAg2z3Iyy5bnQPoHyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762483943; a=rsa-sha256;
	cv=none;
	b=5NxiViWF6rdEsvWFZCi61Ugva6r8EaeiVnsmpsqAtcp5R4P/QFQErnMbaGJhGv5e3f4Zcw
	OGrIFID9KGnYMO0ELQvmgshMe9kGfvW08/Etki3PBSu07sSQ3iPvK7T07PkiYpAqYwdqIe
	xUU/MLOi929kyOwCXAYTFR5J9k7CraQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R4sjC/6n";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bfdc78de-febd-4224-94c7-bb02ee71aefe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762483941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52V3X2Sr5dWVePWtrbdXKFUg9bUNSzwTF2IQfUlVk1g=;
	b=R4sjC/6nQbXI1THBR/jGtbCwNaoEvDMv+9sTHSTixwKUhXSIGW4VrTtL1irRbcCqn7P9Qp
	6ziNkNoTXXiW+NdKynDTP43hyUfoXDL8ikKh1Jw36uhvJUDBVhSX1wrGtPt8pFvf6glDfL
	N6n+N84dA2UpqTPtP/3oAJ/uLdc9OaI=
Date: Fri, 7 Nov 2025 10:52:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
To: Andrew Morton <akpm@linux-foundation.org>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
 <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
 <20251106145213.jblfgslgjzfr3z7h@master>
 <20251106182949.1ffd6f5529aa18139f2ba9f3@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20251106182949.1ffd6f5529aa18139f2ba9f3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ix87tomd789esw3nu6zauy1msfyatpiq
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E2BE1C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1762483943-109455
X-HE-Meta: U2FsdGVkX1+/6itHke8dkD7hQhjH0HqJbzNX2LmnoocJPICFXkVcG1CtBzsnRUUIQxHl029g0EtIsWiPIAOjeXOQMlZvySrP1PrxtPVxAHKa8E0a9oxyPv+2IExr4tEhfAHtk2FBGyPH9w4md8Id4dvp0eixK6gasVK/m1jMUKDBUFR6rCvEGTK00d9Z1hMhUpUYID5Oo6e56gxff08tDDXRDnziJwrqLYRZWxfxRbfu1HBRi/ZxwueixuYvr3VISu0g9zcmvkzlwYQ1YkpQUYjyinuRz1KgElzd5VER8nb8/Qt3KQhlYRTBOjNNv+iWUJut+s2urgQDLX1oiIQ8sLDKRSAy3TiQQbBQUz3tkKjk08av5OpzyJ6FIKLe2MracbQP33Wta7MRIH1D/wDzFqh6fG3H9NsHZpTm9ppqhRL9lp7Jfl3xPIdnPFZw/LVG8+p/6Nc7tjzhAZHcSIvi/jcGonqWU5LdQGx2kjh3dK+nM5xzFfxDeQF3D8Gw3Zy+9ePgWzOsRcpfmk3xu6PnMUREF+5h6GvcgDNxH66bJ+Vhi5z7z2qHch8vBsLnsvLxEIx5YVCWn0wV6fREpGmf7ETUdRJYhVare3vhUpxcqPsfbv2sLDE1qDdw7tEqfZrAKoidGqQtGySGt7e3WtqgZpenwZYQNYuQv2EIJ0LjaGMmgpNejuNeq9I6OCoknHT2sNaF13x304CBwol8zZyPArX3oAox43vu7hAdkVGwvn3E56+HSh4QTLs8NEUM0GRH3uKHGhEk69vUH5lOI2UKzwal/69+3CAVb8JD0XVQQ6Utoof+WoHxIRUzcXbaxjYiB98qurNlscE3BRKcTmbncdDkwqip+Az1OUMlYh1ZbDWE1c51TmEiD5M/RBjbKZTAtXCKeFDsDGnFJKZS5bRc6QAzkj4KvH4sh6HafKD4TWx7fIyuT5pAcHWuPFVxW0U7zs+OowXdvqaoYxdvzBI
 tyvgdGy3
 lA/3hYQ07mOxNlaq/VrJait2hPRfR5L9kAY9cFwD5QSRnKSEn7SPld5MbJSEghImjyPRldHCDyMokmnae2BywQnDuUc4/meW9RKvolum5+Fv0BwmiibB22+ORCMvgTymnFwVsKXcyirgajo+tfxjBxtTIoEe2Xm3NMofFdYF53a81L86ND36pDLGj/r49R2vxMyHHNUCjw09VrMmXqg8xOoFnzOMP9bB+Osp10lfW4/YHoHV1Z6F++PKkkkeSHPKHQy6GilcXWYSQT2/gWBY5bnCqdMCjBak1btV3n9f7pb2d61SiJgFMGWefeEud8ZBzqdmA5WFLALZV2NhDbJ32EA9jVqwN57U6f4Bw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/7/25 10:29 AM, Andrew Morton wrote:
> On Thu, 6 Nov 2025 14:52:13 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> 
>>> +		if (folio_order(folio) > 1) {
>>> +			if (!list_empty(&folio->_deferred_list)) {
>>> +				ds_queue->split_queue_len--;
>>> +				/*
>>> +				 * Reinitialize page_deferred_list after removing the
>>> +				 * page from the split_queue, otherwise a subsequent
>>> +				 * split will see list corruption when checking the
>>> +				 * page_deferred_list.
>>> +				 */
>>> +				list_del_init(&folio->_deferred_list);
>>> +			}
>>> 			if (folio_test_partially_mapped(folio)) {
>>> 				folio_clear_partially_mapped(folio);
>>> 				mod_mthp_stat(folio_order(folio),
>>> 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>> 			}
>>> -			/*
>>> -			 * Reinitialize page_deferred_list after removing the
>>> -			 * page from the split_queue, otherwise a subsequent
>>> -			 * split will see list corruption when checking the
>>> -			 * page_deferred_list.
>>> -			 */
>>> -			list_del_init(&folio->_deferred_list);
>>
>> @Andrew
>>
>> Current mm-new looks not merge the code correctly?
>>
> 
> It happens.  We presently have 29 patches which alter mm/huge_memory.c.
> 
> Thanks for checking.  I'll drop version 5 of "reparent the THP split queue".
> 
> Please check what remains, and send a v6 against tomorrow's
> mm-new/mm-unstable.

OK, will rebase and resend it.




