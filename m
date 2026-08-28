Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F013FC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6BF6B0095; Thu, 27 Aug 2026 22:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0875D6B0096; Thu, 27 Aug 2026 22:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8026B0098; Thu, 27 Aug 2026 22:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C43DF6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:08:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5921C140260
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:08:16 +0000 (UTC)
X-FDA: 85149043392.10.74546A1
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E248C0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:08:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dmXdmk4L;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6or5Gwh9aj9an1QAcL2M34QOTkkE0gjcHqObHAtvn+4=;
	b=fQvnwl1lpLeW9sjWgiqnJECPlmTdcbxmFXna8R5XaaL6A1qZ7XGXzy5tGYjFZHPuYEWbfz
	C7b6bIc0PIsJ9RWQ7Z66uT70SJteoYm6PTunRNYrVWUC25KYNIa9Qef/CeDd9LyIZVpvqi
	0yDepjDZgZiPmi3pTv2dclcZStjXT9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882894;
	b=RFdR/EgiQZmCPQUKI7VW5pLsoO9E0NOaeQczIv795DrFI3pcW6Hw5QcIgN8h8LkjlZOyxU
	jM9jWN66DQI7LXaZsKJN94IMSXNjP0fQ5xmEHzAxZVDwgeD+Q7lNHWokUugJVverM5b8p1
	1xlHNVU/uGdKRC6VnRVkqcn+L6ijcq8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dmXdmk4L;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V2olgPrVx/bw1wkdwsCXU0ioQk+pJBVYyH0u4HOW5i0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787882892; v=1; x=1788487692;
 b=dmXdmk4LBYyRxHay76NehZ2JHDork9SIP8Or9QNvabzkh9qcKhQ8vC4ziTx/iPCdeTpScx6d
 FroKWBejJxYcmzo6gNWQf6lPk0Ss02OnAVtbGd0OAKi5Dh3MD42jXbSVKJvyTFj6gUHiapxTYcV
 j4coaTR6FE8cQUmKMiUPjjjc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce77929620145a86;
	Fri, 28 Aug 2026 02:08:02 +0000
X-Mizu-Trace-ID: ce77929620145a86
X-Migadu-Flow: FLOW_OUT
Message-ID: <ac0d1ef0-1cbd-40d1-9f0f-c12d890be3ec@linux.dev>
Date: Fri, 28 Aug 2026 10:07:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: sink mem_cgroup_uncharge_folios() into
 free_unref_folios()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260827030516.462926-1-ridong.chen@linux.dev>
 <20260827145209.GA3004@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260827145209.GA3004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E248C0004
X-Stat-Signature: k6jms71ib16gaa6ckffsusofrckjpxtd
X-HE-Tag: 1787882894-284801
X-HE-Meta: U2FsdGVkX18l4C/Ws3NtoWWUdcFdgAG3XfoJ6tVcplqbWkyUswRLwE4683HT2n8pIGlLi4FzSDxjwsdmWUn1c7ILN/9+MrmiPKIoiOAluwx7lMVMahXOaAEFCnBuLF9t/jU6Awx+AJwEhc5SuO+XctdmZ8IJkAg+P0wQwtMlxSmf+7V5a/YTx9mPN5bqmvpAoM2GuaSbKbjtg2LvRdTVbDifGshGQHiRSzjmvSfqwK1zMs+5ncDrSNjkF3cyc6b318yiDSOWUsrfeTJY+kIUqx5aL/3UWDxO5fwjcY3bRY1FhNNGJR7jWpROxrbJrcaUEHtvP0hg1hXGR2jFhUdzABi4rLSp14TU4J4SK4Z3u6eIBs/SXpHjao+08LBYVjC4reUfjN6TFFksNg9CTh2toFXNvGmRwDnzis5Uk15KR2qKx6GdnesAaqjs4FcYDR2eQ8LVAh5FoHGbXESdSSl3SZAUQLyPxa4dNECvw5RVJ9O7Yr111XK+4StldanJN0cNJFddwLJr67lLJ+4bUwH8elnhUbnt4pCD4/f4jMAjhBaBgnX0ZEz4vOguJZZYb2tXmOtqIFcczHbAyaOAk4JeqrHOWZ+AFqUWAC2BNzklhKJLl6pgcoG7wxOlUnd010tudeoSnDRJ5nRElSEelGAG3Q6CO5WBn1sb3TL/m5OHGboE6lcMimvLcHRPftH/XhHKSBj8Ax6wzi8oWf8NDOZWpXPI9h5JrtaRvGjPepfdFhGGIybvTYi8QQE4TbspusaPuUCMWh7j7fzcVpINuoYgk3c1sOG77FcZNw5YoEhvus9OYlaB7uoUTMfwdrrPgshw7EYseMD27SxiEPmP0I3nX2EkStxNA2UVP91PYhGhM9mA7fx7JowsnBqEWm4OZFLlgF9sfwopV2oj3swRn7rv4jf1Ey/XBP6Ah74vbmG7hMXB/VglQZrbJN1gTNDvaBzsNlHQ+UYABpn/T5irVQS
 YVOHs/VB
 WYmgqry8Cwm6WzpfC4e2IfXr+Quluop6yjGDE1yYPKZKQQYUWkIEG0UEcn+at/lMWOFD/6WZflx23oDreQl1CnXqjP5W7gKwI5TLV1ewGl7o5dBystCxW46zt+GcpRmrnyRVc8JVuHp+JYxW8ZynVa1wetSHjiisCBOyJfIjvro++htBgJqZpxiMJgGjW/n7D5mIr+iAFEUgHazbuUtWb5YuchEL15Xpi7wfHyx6rPLqABAXPqxny4OmMMqwxxbtb1evJxacH+8PJSiEq9t1sHW07yAqKuWE/cLwoQY60TQlkN7TaPYCRrQg7aZB1NrzMvC1bitahHPLmLPzpfPQajHO+QSP1MSGcwvGv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/27/2026 10:52 PM, Johannes Weiner wrote:
> On Thu, Aug 27, 2026 at 11:05:16AM +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Every caller of free_unref_folios() invokes mem_cgroup_uncharge_folios()
>> on the same batch immediately beforehand.  This pattern is duplicated
>> across shrink_folio_list(), move_folios_to_lru(), folio_batch_move_lru()
>> and folios_put_refs().
>>
>> Move the uncharge into free_unref_folios() itself so the batch is
>> uncharged in one place before the folios are freed.  This removes the
>> repeated boilerplate at every call site and makes it impossible to free
>> a batch without uncharging it first.  No functional change intended.
> 
> Hm, IMO this is confusing. You're making uncharging an included
> service in a subset of the page allocator freeing API. Batch freeing
> uncharges, but single page freeing does not.
> 
> I don't think saving 7 lines is worth that API caveat.

Thanks Johannes.

I thought this could improve cohesion, since we have to uncharge the batch when 
freeing unreferenced folios. However, I didn't consider the symmetry with single 
folio freeing.

I'll just drop the patch if it's causing confusion.

-- 
Best regards
Ridong


