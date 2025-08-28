Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A170ECA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 03:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D015F8E0008; Wed, 27 Aug 2025 23:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8D28E0001; Wed, 27 Aug 2025 23:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C156B8E0008; Wed, 27 Aug 2025 23:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD7168E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:41:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53F2213A34D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:41:47 +0000 (UTC)
X-FDA: 83824767054.26.B91CBD3
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3A79180010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:41:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qknGs9Or;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756352505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3IvQ0HlQISTG9Y08uabppL+Va4vjCOc8DxFpqh3OnA=;
	b=ZaWtHwrX1myOR9yboc1MQhcba0xAWlTyVpbI4V03IpuTXSMSZmhlDcd7hhYJ7CKXUz3x4+
	Eb93hABXtZ8WBZ3Ar3miaertfBFEXq9a1R9v9Zv4s34Zmbjer0sPsfLjRjl4Pm29JA9mz1
	fAmCQ4g4gisn5oGhTo+TuvUoJlRcNOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756352505; a=rsa-sha256;
	cv=none;
	b=3Qt53U+KTEJmTDcJhqD+uskaGfuYDKdWSKVp2p5T77+/XR+6QUqJGxM3A0Z+I9+46wlcBi
	wbF2wkHwcdL+kwzeCmdMJO0xjzsGAlEoKxCEjc77LRxGv8ytplNihq63NKaQE96AhLhM4/
	8KJ2PGdyfYq2FEYFkUCIbBc3Vw66nNk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qknGs9Or;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756352501; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A3IvQ0HlQISTG9Y08uabppL+Va4vjCOc8DxFpqh3OnA=;
	b=qknGs9Or7VTSAxuAMqFK4gYaBckC6mgYd5cLtMXs85rUPfCpARSnrOQSBgM3hmA+Q0uuzTzN4fLVzUxPWy1fhjNLGRV9oCp5GGiNb3dq95W9fRmz71wWVnc1RTESjgyEJkD8cfnhuIVEQ/RKLE1Z6Wdt3wZVjr1RmAKZOJ1CWG0=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmlOm7W_1756352499 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 11:41:40 +0800
Message-ID: <c12b9236-903f-4a8f-aa9e-fd4d9ca1bffd@linux.alibaba.com>
Date: Thu, 28 Aug 2025 11:41:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>,
 Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
 <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3A79180010
X-Stat-Signature: fga3knukn39s5uoawad4xu43ton8a4yi
X-Rspam-User: 
X-HE-Tag: 1756352504-184857
X-HE-Meta: U2FsdGVkX19nAaZAaUVlorCiIF11eK1VTvTKainWtsJ98W/PfFgB/Uyuo8oaOW0PNndrC4zoJFHXjvuc0+wNyzdgraTDJn+GCDCUbmb3Wb8JLvPlLd2WYP1U7Wi8HFbhLdUMQkSDdLYSW8ZQfZhAl2dskfMRy4SZ5mq6sug3NUn6zQBpPxljcqKGoI4EFShU6hziJgdShoCjpCSl68TQ3VB43GmjCm8j1rWx9qIaRN2MXUmNJRXFlDcScxHQyt0rWAzcO9JueZ8PgGzFLyitI/ml/LO4VtfK1Odv67oWzVejbklBl4oUIu83LuxIsXs2rF251NyBkWnB/MsxcEmnNORiPT7bJ8TEdJ2ITycxJdwjyOT84cU5iJsuBEa00td3KCHaagpKuVBIEWyGL2L/cAqgH0lqUwqRVB9NC6tUHqIkNiMJ/iL3EChpx2ChXdgZeTti75465jcT3HVfp7Xqxj0/Hxe1yI1+rkY8AwZirGRlel7BCX550/Db0apRtlDRugWHtujBy3vD8pyIYDg2mS1M+Hhu1FEJg4eonJ7AvhUposaVHoPz8pVEB5JDRsSIbFz9nX8LiPJ0i/QHqzeAVxcUaMjfUNhKvI2Dt6+efK/jDFh5/xTN94VQcK3Kag8XzXqqSsnFfw/WqkYqo/kVLkZCjwCISPfvhn1hrGoldbDOO174sC9lgKUBNFhPdEdG7XKRLuITHt94Q/cJu9OWmAeV//a7gyQv3OMsk3sylHH7dFLdqXb2TqQAtZ04RVyio9WxagrMOtmUh0mw7fNtfiZGFsua5b1TTuBNTzTBul29Ujp5xAGoa5MrCLhdgzOVI4l4dWfdd6HqxBESv4gVsi5PSIl2LqserJqEH9iPoZr0YaOxh5iXnDs0PuuJTn0WoVZUhX6yTtnLNAkCiM5mf2m8pxqaMIRE0NMjboT0wLoNL+YHzGHKVGLIcoXdSnOo0XmE7jxt74XFHi3LndN
 S4smbuRV
 +btibuBm/OHINcDZ/xwTFkr41akH6RgC9G/n7RusIpqxOfu2sTdDm4pSchwJNpEyhZ3zZ9bdyHs12NOrjSA/sjLqueiCXXNHFENdpXcWlxLXNAPYGElddj+jkQsqZgnWAPvXHARk5xbCQ1CF4h4/ZhhrsZHNxre2taDVhE5/lNoDz2Gp97AaSKt/jm1ztWCUpOKm+h/86TQKkPHTZvbqh4RzMW3MlJkqGVHynPJT0FSjVcLe0wm3AWZm0hnYJe9roZcUmfvxkTfEvcC09RvNXvQ1Gq8jhucr4uKUacvX3FRjzF+cE9/RApVdrt57jwzuUi0xcEgxsBxTUTGpR/fvCTU/sTX879naoadCs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/27 22:35, Kairui Song wrote:
> On Wed, Aug 27, 2025 at 4:21 PM Chris Li <chrisl@kernel.org> wrote:
>>
>> On Fri, Aug 22, 2025 at 12:21 PM Kairui Song <ryncsn@gmail.com> wrote:
>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index e9d0d2784cd5..b4d39f2a1e0a 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>>                          count_vm_event(PGMAJFAULT);
>>>                          count_memcg_event_mm(fault_mm, PGMAJFAULT);
>>>                  }
>>> -       } else {
>>> -               swap_update_readahead(folio, NULL, 0);
>>
>> Also this update readahead move to later might have a similar problem.
>> All the bail out in the move will lose the readahead status update.
>>
>> The readahead deed is already done. Missing the status update seems
>> incorrect.
> 
> Thanks for the detailed review.
> 
> The only change I wanted here is that swap readahead update should be
> done after checking the folio still corresponds to the swap entry
> triggering the swapin. That should have slight to none effect compared
> to before considering the extremely tiny time window. We are only
> following the convention more strictly.
> 
> In theory it might even help to reduce false updates: if the folio no
> longer corresponds to the swap entry, we are hitting an unrelated
> folio, doing a readahead update will either mislead vma readahead's
> address hint, or could clean up the readahead flag of an unrelated
> folio without actually using it. If the folio does get hit in the
> future, due to the missing readahead flag, the statistic will go
> wrong.

Yes, that’s what I thought as well.

By the way, can we do it right all at once in patch 1 (I mean the shmem 
changes)?

