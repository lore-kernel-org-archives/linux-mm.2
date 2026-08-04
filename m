Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3256BC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A00B6B00AA; Tue,  4 Aug 2026 00:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1507F6B00AF; Tue,  4 Aug 2026 00:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091036B00B4; Tue,  4 Aug 2026 00:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75236B00AA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:19:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5772F408C5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:19:58 +0000 (UTC)
X-FDA: 85062284076.24.7F831C5
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D803140004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:19:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U19WtwYS;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=175EbZHBL3F1dS8YR8Z8r9c4iZSEBgt9aiiE8BBHiOk=;
	b=RdVqYF1A4R2QX/8YpOJNCS5BvcHbbxQ4oR9W+2ZKE7CphpORX2085noVRxOMiWuIGoKTsU
	92vSC3F6akXAkQpX6f9fMhyokTAe5F/k6rGTKdS4OXlA/A+DxMTOMANgamarKWMJTOypG2
	h4VQntjhZm84CVd0U/KtFhTET6hKQkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817196;
	b=OARCFf/0DdsNWtqQxTHoqPNWxhP0Vp26u2uG8wLd+DyzZm9pRkT2KMSaYkPBoRNnrLxJFW
	Gb9SmIvFdpcw/wtewa3qzag6NbxnvBQW9aGjY45x0AdKp+E9xDkvOOfZEUSjuQg+U+ZO7t
	WFVhRm/JFaqZLO4hy7ukzQaw7fZP0r0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U19WtwYS;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b222ef30-10b6-43a2-8f77-f6108182ba77@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785815514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=175EbZHBL3F1dS8YR8Z8r9c4iZSEBgt9aiiE8BBHiOk=;
	b=U19WtwYSY+G/DxpEAUy0NvLxRrtwwQB3fY/g3kYKVDJ5jSacqCxKWrwubGS+4hgGL6Ly+K
	K9Z0ZUvXaCyC89C5BoKR8x3xVMQ5ztYfY0QEsUYtkfYX2sTWdQi5kUb5LDM6nnh9fppXoK
	veIcqGqIT/+lBi64DhqGRk+uyws/YcI=
Date: Tue, 4 Aug 2026 11:51:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/3] make unused huge shrinker memcg aware
To: "David Hildenbrand (Arm)" <david@kernel.org>, hughd@google.com,
 baolin.wang@linux.alibaba.com, usama.arif@linux.dev, brauner@kernel.org,
 akpm@linux-foundation.org, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
 <944bfc30-68e4-4ccb-8b00-f0f86d27cb56@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <944bfc30-68e4-4ccb-8b00-f0f86d27cb56@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: woszx4ditdb6m6pwgmpcbr1awkegfajj
X-Rspamd-Queue-Id: 9D803140004
X-HE-Tag: 1785817196-256613
X-HE-Meta: U2FsdGVkX1+vjav/Ujayi8faHPv6ncu5VxgvdJkM87d2VpL3Fao+4M4y3JHCNMivA0rf6LFKSk7b82tis5Yg43xfP58KUcJB136cwRX+AYb8oCJUKKuJJ8diIZY9BoScyYzVe2qRHzWber585gN5LqskI4XCgwiEiV0TWvzNlE88L+4LTWZjCEL4BOSQkzG3+T3L6K3pKlFbSRxk7tZAWZLxmQwXcUoIO3c7Wk1n/ZK69MXFfkms7fJzqCrjvqbU7tPihvTAmdfaZmaegs50xe9eFBQxMUchm6m0OyMTiJxgKD0hWI6Zp39v8c0CzVS8n/LtN+gDAcgA2OwzRuJfdC+YzvalZT14OD2AiFeQPeh5zfp78qqj6xtHuQbH36nLtldyGKW6NKl5zvT+q9+JuilzqaDvfkXDkiQNiFOHoTxC0IOLI2Zoya80JGWBhbQcDIUHtdU/1Q737d5yp5YYSxyVMeSZC7XHWAhWCJARPMI8E/3PCXkR27ghIqTh2OyllKJ7vhWWTdlUru20q5LkwG2eMNaciN73y/bPRHlphEWRlqATbZ1gbWjr3uTwZ46KLQLY4f/VoqtjyJbC6jdnT9bu3rIcsS2PG0hOE5PKZzlHBgH1phwNYPVnaezYnbKhX6bi2STLSv4PH7+MHb4T6EwLE3+wKG19N/BHXevW9ai+LkToWCv06NvMHXCj/d7isHUk0BmXBhbWwQydSz2HIH59aYyF02eNO82rqDzbVVmHK2DF5VkY+aQfOxR4J/cmic7DzjP/NWlPzrkIWTAzFibqE1WXqsUAsCoynaGTJDNIsxCx4q8HxT6LNeywTdAZD5IV+VP3gkF9N2RlgdBa5iSLci82JSlsFvrcenmCjeWE7uWMllLEDPyFhsesRakzTYMCqsWiIxvC8eCjo4bDmUHMBf2DDIOYiePqMBFK18gYbZJPKmcAAAZ6WiBTZz2H0LUDPegrEjqX8fUqoap
 vEunXdr6
 YORKZvE7mT/Z0ioS5blH4ixDRURkjpy6yCkJC74egvOBt30JonN63uqXOSMj5yeR7Ff/lBXqoz2jvx95Ul+EkYYg87NYJ3fbecWpztFIKbWpjZJF5B5LtNNJaAu7nGYXwKY7j13t97jBIl0zgBNakvQk0SD+YrUXi+l10RxStv4pEC1RZZnGkp0STeEvdG88PcHAErMWj0MEO6R03KjZR1D8PXyoxMdYGvC8e43pjbi52MyTLuSLhpJZu4vDf9OkU3EMk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 8/3/26 8:21 PM, David Hildenbrand (Arm) wrote:
> On 8/3/26 10:46, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> I'm missing description and motivation here.

My bad, since v1 was just a single patch, I got lazy and didn't bother
adding a cover letter description later on.

> 
> This is only about shrinking huge pages that span end of shmem files.
> 
> Is this really a problem? And if so, why?

Yes, this is a real-world problem that we encountered in production.

The root cause is that shmem unused shrinker used to be non-memcg-aware.
This could lead to a scenario where reclaim triggered by one memcg A
reclaims the shmem of another memcg B, causing unexpected impact on it.

Even worse, memcg A might have no reclaimable shmem at all, making this
completely useless work and incurring some performance overhead.

such as:

tid 11340 comm scanner locked a page for 182264 us! kstack:
         unlock_page+1
         split_huge_page_to_list+3135
         shmem_unused_huge_shrink+767
         super_cache_scan+329
         do_shrink_slab+291
         shrink_slab+533
         shrink_node+400
         do_try_to_free_pages+206
         try_to_free_mem_cgroup_pages+262
         try_charge_memcg+591
         mem_cgroup_charge+136
         __handle_mm_fault+2431
         handle_mm_fault+194
         do_user_addr_fault+462
         __do_page_fault+176
         do_page_fault+48
         page_fault+62

Later, with Usama's patch [1], the shmem unused shrinker is no longer
triggered during memcg-level reclaim. But this actually doesn't make
sense either, since we can clearly just reclaim from memcg A individuallty.

[1]. 
https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/

Thanks,
Qi


> 


