Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFADCFD31C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 09:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B2A6B0023; Mon, 24 Nov 2025 04:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702FF6B0024; Mon, 24 Nov 2025 04:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618AD6B0026; Mon, 24 Nov 2025 04:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49FE16B0023
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:27:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 579A312A15
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:27:38 +0000 (UTC)
X-FDA: 84144972996.19.A4B9CFF
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0C8320009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:27:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X7nJ2UMz;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763976456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKk3rLELPtCaq6kSIZA6Ay0Og8Sjup640I4FGfHPm18=;
	b=GOXO7F6ymeeMIMsyStnPCKEoVpY4eLJQPn2IYQPKjTDg4oS1VDne2brtmT+4pqkxefC82s
	/LlnBatFxUe0R5sRFJ4x/hQKtgJHb7pQ19aB+wqmhUMUl/cURvAGJ2k+Zk2lB/6YgBREnm
	plPfx9z7jx9uJelW4pMv+THD/YqYxyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763976456; a=rsa-sha256;
	cv=none;
	b=hOBJGzx/jAmR25spoW5Rs/6OcojPWodnNARe8k17xZ8ddNjrJvFcNG5rSF3uRXpOh9z8Ik
	wjg8SrksT77LoZTuYqdhE42OUWMEW4Nha8gb/ZOrjHdDmH8mSF3ci55QEfRgBk0hPXX5ci
	avdiXUSJV6IjV00YrWf6Gn8WSkqodKc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X7nJ2UMz;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0f292735-4b13-417f-bc65-82cebd2040a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763976450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKk3rLELPtCaq6kSIZA6Ay0Og8Sjup640I4FGfHPm18=;
	b=X7nJ2UMzDJHfWZPxEov3YNED1bugp2p6Vp1qyvTPFJ0oXYrT9AKVJQpzimu8qNi35CPj9Q
	OAFP3YGNXwaDjxXq8uiNGscumIaaWgPPHFajoszsXAnaAKQqpRaDkDIM+TzwHtJJ5SEp8J
	xiwO/Ix4kH9Pyinf19KdM7TL+TZilQs=
Date: Mon, 24 Nov 2025 17:27:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/khugepaged: Fix skipping of alloc sleep after second
 failure
To: Zhiheng Tao <junchuan.tzh@antgroup.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shy828301@gmail.com, zokeefe@google.com,
 peterx@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <1763965157-58413-1-git-send-email-junchuan.tzh@antgroup.com>
 <dfe192a8-4a88-407a-83c2-976d953a2227@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <dfe192a8-4a88-407a-83c2-976d953a2227@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C0C8320009
X-Stat-Signature: xikaosc9pww8qpeh5ah5y7w1fzo66u81
X-HE-Tag: 1763976454-770848
X-HE-Meta: U2FsdGVkX1/0/EaN6meYfekrLawlwr2oMMd75tm8SayuCPufkCtF27LZbjYR0r9LIN7/7C7roQtkQmOBEnmJx9MlXUchvBPt4f1klxiOyFWQKSAfHQYpH6uaaX27a+aJT1WaWJy1VBnWeqKb2EM+X158k1027mSf3itfMxGFvW5kJ0CnGfL09YknwsNcwFKo7wHu8lp6Xp18flaOmowUhuk3kl6EL8/91jwdQyYp3joio7eEYl+HEoWz14bwW3fsO8bM+9zmsv96pSqBD6QgmGqMwQCKoUueTTSQAKFl3InztlrVFME/KmmxZXNJMI8oIAlAB6XF5t6Wip4FLkGhAy3HCNknrFNZhQec/jsF/asxcUVleel60ApmG6NnFHoycmuE4Vg1oZFnjouvguJ3LQED5eQAoSaHucmA6dikzoaN5y6v/VqgbvGBIfU1Gx2D0ck88lnlyHaBEPP1x+cy38gguQhOh0fFCaJ3XVp2PMCVFX+n9fV91AaGTpLSmulJPjcJZ3W0YdCDW1GdN+AwNCxCp6Vz34brHQKXWx2C15ADzLO78XI8NGrU4VI6DUI/vxWiVeRWlfj5i3Z/o/PoVREwsj6CjfXEcTNozv+v8tnPzccLwmpXAp8kgcdl2/fA4MrEhNsIOsNbespnKx/6D2XUr44K6m6i2c2bPymPAVYZM4qvdwVPXTgc9QbVAKEo6uF3+Q0GJ4edoLQLs0ZZ465bCzsCta3yhUyLtMSujXjnlikzKE4M3R+ihPAFrvi2wkmLPyMro9EfEDAV0WznObmzhZjQZhMVXIxvJ8PiusS6S+4tXVbyXgsQBSEomVBXLKI74My/MbByFXvPC7rZ1lR4VoZLWmzOAKKPdDKBYl6VNiMTQ3fyTGMYJya3k+8gWuAY3SEIUmROU9xB9GZl8mKKZoKa1Jyb2L82UcR9P2c0L8XzHDhheVMNtQXsoR1gbZRrZGAAqb1KNvPdPFH
 KqVkEXIs
 //5dccQ6kdOT7q48DiOYOnew79M+SS3V+erYeUIG2652N9tJGGYunrRdTfj4Migbc55eIKAUKyS+I13kw8WY7GCyE+X714bnLNx+8rkgJq7iuY7JnjnuXp1Z8YxsQUPQWWD5UtU/jrTcPz8X+ihDT1UwprdH0f7SvECkUD3mQaTtoauo+Gvyj9T94DyNYBNwjGmcg0tKF9hX5DepO+CWZHClz3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/24 17:14, David Hildenbrand (Red Hat) wrote:
> On 11/24/25 07:19, Zhiheng Tao wrote:
>> In khugepaged_do_scan(), two consecutive allocation failures cause
>> the logic to skip the dedicated 60s throttling sleep
>> (khugepaged_alloc_sleep_millisecs), forcing a fallback to the
>> shorter 10s scanning interval via the outer loop
>>
>> Since fragmentation is unlikely to resolve in 10s, this results in
>> wasted CPU cycles on immediate retries.
> 
> Why shouldn't memory comapction be able to compact a single THP in 10s?
> 
> Why should it resolve in 60s?
> 
>>
>> Reorder the failure logic to ensure khugepaged_alloc_sleep() is
>> always called on each allocation failure.
>>
>> Fixes: c6a7f445a272 ("mm: khugepaged: don't carry huge page to the 
>> next loop for !CONFIG_NUMA")
> 
> What are we fixing here? This sounds like a change that might be better 
> on some systems, but worse on others?

Seems like we're not honoring khugepaged_alloc_sleep_millisecs on the
second allocation failure... but is that actually a problem?

> 
> We really need more information on when/how an issue was hit, and how 
> this patch here really moves the needle in any way.

+1



