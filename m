Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A3ECD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6517B6B008C; Wed, 10 Jun 2026 20:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602006B0092; Wed, 10 Jun 2026 20:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517C76B0093; Wed, 10 Jun 2026 20:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 438626B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:52:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D55ECA03E6
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:52:58 +0000 (UTC)
X-FDA: 84865807236.14.0E08E78
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf30.hostedemail.com (Postfix) with ESMTP id C11458000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:52:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OmbAknQr;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781139177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ST8ZWi81n2wInQZAT/+VOZXtaPdJeSF4yd+dmtqzVMI=;
	b=8jgrHNwvix0kEyHPciOM+C1gnxZuYqlWFnkq8QykEYt9eWQa69cI27ZfXTRaa8+7/fTtCu
	FSzsSS4fGI2LsUm/1InDaVwTiZ9lN4DUnO10IqVLZQDT3C8PWAHmz/xC4kwinax0w8YxxN
	n5xLh0niDm2hzioLu7O6zo8wwsCMvUk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OmbAknQr;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781139177;
	b=AjYK50kUX/73lPVQ5Ly2GqhkZYNMIsNaA1ee2wAMYKBoI3eJ7y4W/YN7w0TnhIE8Onufs9
	6yc0mcm0KND7WpLW4CkO1zvhmMkCAhBGG8/OJlrdtpNKjatzdsDqD0uLjcdyLmnxgzF9hO
	g6OtnP6hAQSOtA706ZXsMfNC6Kf8E3I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781139173; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ST8ZWi81n2wInQZAT/+VOZXtaPdJeSF4yd+dmtqzVMI=;
	b=OmbAknQrWLrWjqOgcOko0ieNmucRmO4WgVtrLhJ0S5KsTMI5djKimsAOXiuhfbyn0cKVJ6FbQSP70r4/RYFbr+05fKs3JjT72i0lfZJ8jfsYVVwXl2NhPknJsITm+cOrxvZzLDVMWHrGSPxKTAQZyzOT1aOPHaM1HfKaHz6iPO8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4bqNLG_1781139171;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4bqNLG_1781139171 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 08:52:52 +0800
Message-ID: <0fe97965-671c-41e1-8367-95a5968c7bab@linux.alibaba.com>
Date: Thu, 11 Jun 2026 08:52:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/11] add shmem mTHP collapse support
To: Nico Pache <npache@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <CAA1CXcARRvYChZbxfLg1oTh7RdKGqJUFg7M_vCK162v0ncKhVQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAA1CXcARRvYChZbxfLg1oTh7RdKGqJUFg7M_vCK162v0ncKhVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C11458000C
X-Stat-Signature: skj8pm3kjhs41k1b9qc6oaifa8kr948p
X-Rspam-User: 
X-HE-Tag: 1781139175-833774
X-HE-Meta: U2FsdGVkX1/l1I+FHcO3KvKnatb4ZoM/yGpDy2LhP7s6a24Out1aS/tYkE/bXh1mu6ZLzLzXuiDWi3tU3YKSIvRaeTHq5CRZPlVco7ro/Sx6+v9TZaz7JZ1tfUGJHnzMj+FD2NqWGluP8/KSTlOVkU55gXhZXfS8hZ1dJi4eRQVmAp4ezY0FjcH6qPLgDi8R3o6MEdSoqDJNP2cK90ozNqLrbfDZUMDg2o4rwZ99ymrICRPOI+C0cGsVd32SuJZCEKJcRaYFWI98XyMGrw8Eyg71seDgUOZTs/Ddu1Jx1rNYVzvRIvpytfB9JhqP3Z0yX7qPXeww/s5QE2oEpgdllypb48+v67TJtvNWSvtXpdcxxljLu11uLib4q8LXUKjSsa9zc3HV99JyvL/3ovKFJyfgsbOQ2SZ4Xl4CM/vCzkkv92tuybDp4diZzFVfIL7nqQu/pznalGWSPxQyw6OqySoHtDfVN3vIFyq7GaTIWrvqpuEtzJJQUXiAFTQnZewWhMqzWlmRQKjIl4OWaKesXpaLrHhHxRUpYcMXto94K3SrZNKfCfD2AYF+G6O9DrYUweN/azhITWh9xVwKQ2OmZ7kyTguli4RPya6L/KeYvPHJfjoZExE1Hw9jtbAQ3FcoYMNhGkwiZE+Hgf6AhGLzyEJvKFfGtu1NkK4moQulz4b7AzQlMTUB6YgzaOtLKEKx/t4WFPf6sopnO12JA+O1cSJe4P8MZz+vDtaNjFtZzGwLLpZBKdDduGBHB5DmpF9AY4kiqH6/B7SPnZB1CuFAQNgRJYi0KsB4V6fhO39ioqD9bzqIUnEF8wbvm9V5UfMHnlxDeVJ1VaswHT+e8JYttjRrIwUcPaCT8S53s1KZBn3NhUrju0G4HqOJUACE/I8mbocXPxenTw06oToMpzmg8g7U8WRA82oCxbWnzGKD7IFl7B/k/+14Im8DjhjRcWYoWkKxRGIX85EXLJ0/smE
 h8luNEBZ
 hCnuXK7plJGkuT+5LOek8+1DjTuTvvxBEhAA0oA+HkxdBdL39f91Kv/9FFWLh4yktErYE3/ZIAwOKUYZ2vB5Uwf5V+nWgX3PftFLKZEVVmRDeoJPw80bBN3wBd1c9Ws+K79OmUM78KJddb15w4mVhD96gAtwInAs4rYPXEQRzSpqA7H/1UcUBD+JxbxOkf5KWM56v8LHaNPSz4kpVv9NjfSiIYOdwi5HnAvXPXDAlwFZpqp1EE2s+SeUpInusp5bo3AzUGupp0Tfo1/WEMICgxjpFoNXlb/QkpU5s9baeJBwZlYoDGT3z2ienDWcSgS0KMY8A6rqiSCozxcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/11/26 12:28 AM, Nico Pache wrote:
> On Wed, Jun 10, 2026 at 4:29 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> (Note: this patchset is not targeting v7.2, but posted for early feedback.)
>>
>> This is a follow-up patchset for mTHP collapse to support shmem mTHP collapse,
>> which is based on Nico's patchset[1].
>>
>> The shmem mTHP collapse strategy follows the anonymous mTHP collapse approach:
>> track present pages via a bitmap while scanning PMD ranges for collapse candidates,
>> then use the bitmap after the scan completes to determine the most efficient
>> mTHP order to collapse to. Built on the basic framework added for anonymous
>> mTHP collapse, the shmem mTHP collapse implementation is straightforward
>> (Thanks for Nico's work).
> 
> As promised I will review this series :)

Great. Thanks.

>> In addition, I have added some anon/shmem mTHP collapse selftests, and now all
>> khugepaged test cases can pass.
> 
> Thank you for doing that!!
> 
> I was just working on adding the anon mTHP selftests. Any chance we
> can separate out those bits and just send a series for adding anon
> mTHP selftests without the file-related changes? Then your series adds
> the bits you need here for shmem collapse? Thank you for doing all the
> heavy lifting there to generalize those functions :)
It's easy to separate out the anon mTHP selftests, but I'd like to get 
some feedback first. Once everyone feels the selftests are in reasonable 
shape, I'd appreciate help with review and testing (and even adding more 
test cases on top of them).

