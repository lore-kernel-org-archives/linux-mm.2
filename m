Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A51F8FA80
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D142A6B008A; Tue, 21 Apr 2026 10:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5556B008C; Tue, 21 Apr 2026 10:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3996B0092; Tue, 21 Apr 2026 10:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A59F96B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:07:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50280160EA7
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:07:02 +0000 (UTC)
X-FDA: 84682739484.03.6098B9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 911CE140004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:07:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXctiPqc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776780420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iChZRsQiNXg+6iyKpig2XKY9Ixjs8tY7PFji4LMnIyI=;
	b=mKYiTn6THgUXDPGnTpvl6GdvigFAQxyT0jOjvDKcBsfF9IR8THnx+ZqOVwJRClAj7kLyiP
	qvy0AfTR7VWgwSGPTTM21xtdZYqmEQiRL3N9aqstM5Vw9js6kY9f0939yqUjKSvmG1W1vB
	KDmISepVYPiZCD9z7BPjZ5zMaPfAMNc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXctiPqc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776780420; a=rsa-sha256;
	cv=none;
	b=GEemIRthWYgmoSOp8HBujToRV5K2j5t7fuKf1AaoDnE+MidFwEcORzlXPZSS/n7fJdSygs
	cWIrLOnL35pxPTqvRTKz3kYzP1EzFUqUoQw3q7z5cSB1UoQ3k9I0LzMbk1d2HBgSoz/3Qp
	O1gqsZFd341akjZhSaPWekncAwhQtIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23BB46001A;
	Tue, 21 Apr 2026 14:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421BBC2BCB0;
	Tue, 21 Apr 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776780419;
	bh=3hKwDYgfWHkAS2Xie/PyDCZVOfFJ7zz3gi89F6UCldQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HXctiPqcixf5ofRlrw+62WSquXdeg/boIUpGLomwpKVj4626AgypM/t2M8rYDENXj
	 YOkXcx/yKvz5/s4jyifY2mW1flXNaCsWvSYxmK0gJ7XjQNEiVZzlg2lfZ63gFBIv2E
	 4Oz02TVBb94YAw/BBhK3vlGdPOyluJGZrqi9pGjW+7sExI2po7aP2cIWvS3/isKdkW
	 0WFptr0QEHFyxDBlSQ/4PyZYGpJH4yc0808O02A8Xc/Fbe9m9Jc2n1pLypjpfsci9C
	 J9KNBIVaIVCw2Ro1cSCuSHjrQQnsPTq1cFm9KpqdsnEbU4RAFdSE9UGrr5VIWJf7uh
	 RUCtDOFmetuaA==
Message-ID: <eb6a6dcc-9e48-47b2-9805-d14b121278ad@kernel.org>
Date: Tue, 21 Apr 2026 16:06:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: Zi Yan <ziy@nvidia.com>
Cc: Hrushikesh Salunke <hsalunke@amd.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260421042451.76918-1-hsalunke@amd.com>
 <C22AEA85-4EF6-458C-A735-9F7E48934C83@nvidia.com>
 <a6182e60-9b81-43cd-aa25-09e54d20d13f@kernel.org>
 <23A49388-EF68-4055-B620-54FD92FF2EC8@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <23A49388-EF68-4055-B620-54FD92FF2EC8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 911CE140004
X-Stat-Signature: pnmo8bern9ju1qq661rsnzwud5dik5dn
X-HE-Tag: 1776780420-131090
X-HE-Meta: U2FsdGVkX1/a89LZ9BVg0mnw7T6OxpCdDCntjRWdrmt0f162e3mfk31txggLmRfFUWWULqdMcWiv6tSMGyj/xB0LU7gWiu5bFkGWaLM/6Zr9IA/zwV649AEf6dSZRqknDNSnxSrO8ZGYjZZwd/2z5OpSgh6Gun1rOoaq5ie+KNdbzDe6v5AdNUahGylo2lMzn/D20aS9O3CXlL4cIr1elME6mFakkyBjLvjQRMH7B9uYmWUxVBYiq7/BHTjFZJKEPWUi2fNu1SD5BfyONIpKCKseuPgQ7a1OD3vSSOgmyPTGqh7VbVtSeHav85N/PHXYjKXa2SL+qGsMVOz/PKdCNmX+UzfOP28ENt6hn65w+IBKqLmOPukmpJTh4BgLsHuPWvwsGpJJikbhNM18e7ArTSeMLsZNkjZbqLZhkRmmIHzWCo0f5Lf/dWAAU8Xa1bjirYLq7d/ONnDWAuzQiCbmzoeEJocnIcTEFSciGfLglqQTG6BGFeFgz8lEqqxTj5vzV0ZUA1vOQ8sw2Dkm0QyPcDbAhw/KWWXR5rbW8kinJTy6bpKAujsa8lsfaa+oQ5+52mvh3+doKSeD2eEoIV7QVOId7UF0rt5sbwUCSejUWq8F45JERXftweS5sFxWRJ28ih8hdAnr62lyyXFiyngrVYK09iw+ym4RMRFJnyWQxxDlLHPEA7Vlh1b1m6bIYyBDLODdAIPZithiP8E05Xg1y4bQfGy5QVXjyuzli/UggMp2LVBFoEXiF1y7Y4Pjy6cZcv/j37IBo0ip94HmOwr7QTymBNoDR4+g8ZRtL9fx6Fg/ga9jSUoQmGFILKCGs7LjIYw9+bV9CUk0+d59ZmGpuWhMuwocJbv+eVvfhEDEk2ui47Im0lNaffkxeYXKV0CGCK91zIT3anFAssGCksMcPje23h9vPIi0A68D64XJ8gnWJlI8KzPhY9zLD9I5rufidvV+qfK2DLRlPqy2D18
 VuRJS3b5
 cgxuIfMj7PZ9Wl7BWu9X+Ra3L/bZoPWENkNOkYMNvp8j0GGaG5oAvmk8kNxrsWZFGeWf5S+3hg2ZOt2lVZ0CMHSgcp4SWrA6LI5/mZqw5aST7BNm2dCPTOQCHFfIh/6BNQNVbrbIqiWhYrrcE76emyrYMdOjIwDJgDBjS3NpM4z0iK8/pFpA+Evoc6lEZPmNFAkKGt/2zxbyVj5yT6nd2gWMLerDJpQhABksRXsNpdP9ABlD6noYC9jSiNmZd6KbNuIkejD3oibCsExaXgJP5qRzttnk9o8loMrV8Odn7f0/9GR+U7yXWwno13A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 16:03, Zi Yan wrote:
> On 21 Apr 2026, at 9:57, David Hildenbrand (Arm) wrote:
> 
>> On 4/21/26 15:44, Zi Yan wrote:
>>>
>>>
>>> kasan_reset_tag() here removes the tag from page address, so that
>>> clear_pages() can use the right kaddr. I thought each page needs
>>> a kasan_reset_tag(). No need to respond here, as I am reading
>>> the code and trying to understand how it works.
>>
>> It's all confusing. But we really just turn the pointer into an untagged
>> pointer here, once.
> 
> Yes, I realized that after reading kasan_reset_tag() implementation.
> 
>>
>> So I think this is ok.
>>
>> I do wonder, though, whether we want to move the
>> kasan_disable_current/kasan_enable_current into the
>> clear_highpages_kasan_tagged().
> 
> This sounds reasonable to me. And also replace kernel_init_pages()
> with clear_highpages_kasan_tagged(), since kernel_init_pages()
> will be a wrapper then.

Agreed.

-- 
Cheers,

David

