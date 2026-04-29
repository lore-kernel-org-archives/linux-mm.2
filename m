Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A2FFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 09:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24096B0088; Wed, 29 Apr 2026 05:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4BB6B008A; Wed, 29 Apr 2026 05:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA4D6B008C; Wed, 29 Apr 2026 05:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5916B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:19:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A77FD1C10F0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:14:34 +0000 (UTC)
X-FDA: 84711032868.25.480C7E9
Received: from mail-m82102.xmail.ntesmail.com (mail-m82102.xmail.ntesmail.com [156.224.82.102])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8A56C0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:14:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.102 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777454071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wSqB6YhjcZ06N6Or3saPafRnUc8lRP6hzTf2R0QKHiA=;
	b=WtlLs3rplDUGaSTw3mZURcL5rMdBV3JVJWVkfrmlhZoH73S02y7Tmbq/YMclntADwlRzaH
	NNS8denyuyJnF6GfU4BbtTB6CaS0l+2IqxrZGB0fHgmwbvyu3rgh0F23u6vEkN+pVtXUtt
	9qFd0wxbM4b0HglBqnxYyBl4rr+IECM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777454071; a=rsa-sha256;
	cv=none;
	b=07/jNnl22gQaD7vrIkF2kc5sTKWc8z2QMrBiEq996itS+xaS3dcxBBrRwO9anLRQes/yhb
	C4Kj/H/reD7QTz6IutODTT/Xd+36KtsHAfFf8dd4NlEZSrnmaslxyIG18d9vGESF7q8GeX
	2un7/55+rQ7sNWxNeuY1ZrvNe3kmQEE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.102 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 198a320f7;
	Wed, 29 Apr 2026 17:14:25 +0800 (GMT+08:00)
Message-ID: <327ba94a-2d0b-4e2f-89d6-b261a6cfa433@easystack.cn>
Date: Wed, 29 Apr 2026 17:14:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm/page_owner: document page_owner filter features
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260429013514.88985-1-sj@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260429013514.88985-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd884a8000229kunm27c5ff541b2c74
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHUMaVkNDTU9CTB5IT0JLTVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8A56C0008
X-Stat-Signature: nddex6b18t4wiqh5ffpgmx9mbxzsqcfx
X-Rspam-User: 
X-HE-Tag: 1777454070-446092
X-HE-Meta: U2FsdGVkX1/YEWjeBuhfxEe8CxQazAg1cuVO73yP5PcQZtqkqkxy36AB2A+TcDq8Cma1LieH2+M5iqN2/tdaqacaIcHGhK76A0NBIfqDBCchsd5mVTV6ppD9ocgbg9db27PFm7FtR/uGYqxDfNZB4+xAje8O7vW2eWBAIuiM0axnDRa/a7fZRkZPO/lnQzl6wKWJGjmZTrb/2vsItOzaMsOx0mYdHlgHAYZZIA4WzhbSmREra2nLtOORTO5u1uJnz53UK9DBPogxekC7SYo15dD0qRWs/g/W+pejiZyUVV87R2ELi8nfycLKSmAn58vcdHKQzpLx/LKPRXsGqQkc3sqUreeAEV8/aYq2GAgjNeuVlhN73s4Tf8p4FFat9ZRLOCiivJLM+UoZx8a+ffTJWovMRJydErrmBkHSzmx9Lat/C1OVIxFHKfBgbRhuJurggL7WZzSNzT9o4DZOoTfNOOJfLTkqs/8j9yYKAwMP7oZ1KYZsh1Wi42egO2vu+I3n1O3PYIews4BgB4X/Oaks5Kr8Y/ARQOwc4JdonFWEitDbIOgFbFCiedxuoQqQ18mNBAS8V4/xBMgEva87Yt5rgvBkhM/bWUZqQ4i2e9BudMlPFLnuNSWCmLTgjujNlqhnNCldNuNwP8UNNVnmb7oY8GUJbpTE9LilS++pG1guFcSfmm+Z/PFXKVsigPo74fz3yYrTRN8433SWSR26pxiY2G7s/51+NGXF7pQpIO1O+bY1RxgurPqzgbksA9vwbCWw8yXJ5fZfpygMx/4yy6WckD5CK6KfI8Jen2OleNMPJRIeySlfUPI5vt2jxCfnm/CfsGGvTkuOfCzEzwW7t6d8vIg/IMc93UF0IuVk1HxHz2bpLKq2aUuxA4iO6KY6Y6Q83uPWxYeejuys4/dUmYgQEgKohmaSFduQyORrpGolOhYMqOpNRUu1CfEpSs+0srLQyJ1R81i1N4SFPOrA1EV
 1NX4KPYW
 oeGdq23Qw5w2cVk49b/FJSrx2MrWr4V5ni3fR974xL10OUMqkSK8404JnqqvGveSI5gGj8vNKdXibPKlDK8g9IVpnyuWXwD1iTZ+fOsmJCMA8qdi/hqsTVryf/Chjj3n1EnBXbpEmpTvUTAgbE5pM5Kw3PEzKHI+019+FaorqoAG4uEvk4562R4gxV2Hlq0HgVofs8EVD/bmG2kRAl5+QbdTCHCPtYp9wpVUz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/29 09:35, SeongJae Park 写道:
> On Tue, 28 Apr 2026 15:11:12 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> Add documentation for the page_owner filter functionality, including:
>> - Print mode filter (full stack vs stack handle)
>> - NUMA node filter (single node, multiple nodes, ranges)
>> - Usage examples for both filters
>>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> ---
>>
>> Changes in v3:
>> - New patch to document filter features as requested by Andrew Morton
>> ---
>>   Documentation/mm/page_owner.rst | 55 ++++++++++++++++++++++++++++++++-
>>   1 file changed, 54 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
>> index 6b12f3b007ec..6261366d33fe 100644
>> --- a/Documentation/mm/page_owner.rst
>> +++ b/Documentation/mm/page_owner.rst
>> @@ -74,7 +74,17 @@ Usage
>>   
>>   3) Do the job that you want to debug.
>>   
>> -4) Analyze information from page owner::
>> +4) (Optional) Use filters to focus on specific memory allocations::
>> +
>> +    cd /sys/kernel/debug/page_owner_filter
>> +
>> +    # Print only stack handles instead of full traces
>> +    echo 1 > print_mode
>> +
>> +    # Filter by NUMA nodes
>> +    echo "0,2-3" > nid
> 
> Nit.  Other parts of the document uses tab for the indentation, while the above
> new snippet is using four spaces.  How about using tab for the consistency?
> 
>> +
>> +5) Analyze information from page owner::
>>   
>>   	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
>>   	cat stacks.txt
>> @@ -238,6 +248,49 @@ Usage
>>   				./page_owner_sort <input> <output> --tgid=1,2,3
>>   				./page_owner_sort <input> <output> --name name1,name2
>>   
>> +Page Owner Filters
>> +==================
>> +
>> +The page_owner feature provides filtering capabilities to focus on specific
>> +memory allocations (e.g., by NUMA node). Filters are controlled through debugfs
>> +files in ``/sys/kernel/debug/page_owner_filter/``.
>> +
>> +Print Mode Filter
>> +-----------------
>> +
>> +The ``print_mode`` file controls the level of detail in stack trace output.
>> +
>> +Available modes:
>> +
>> +- ``0`` (default): Print full stack traces
>> +- ``1``: Print only stack handles
>> +
>> +The ``print_mode=1`` output format::
>> +
>> +    Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
>> +    pid 1, tgid 1 (systemd), ts 349667370 ns
>> +    PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
>> +    Flags 0x33fffe0000004124(...)
>> +    handle: 17432583
> 
> Tab for indentation?
> 
>> +
>> +To retrieve the full stack trace for a handle, use::
>> +
>> +    cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles
> 
> Tab?
> 
>> +
>> +NUMA Node Filter
>> +----------------
>> +
>> +The ``nid`` file filters pages by NUMA node. This is useful for NUMA-aware
>> +environments to analyze node-specific memory allocation.
>> +
>> +Supported input formats:
>> +
>> +- Single node: ``echo "2" > nid``
>> +- Multiple nodes: ``echo "0,2,3" > nid``
>> +- Node range: ``echo "0-3" > nid``
>> +- Mixed format: ``echo "0,2-4,7" > nid``
>> +- Disable filter: ``echo "-1" > nid``
>> +
>>   STANDARD FORMAT SPECIFIERS
>>   ==========================
>>   ::
>> -- 
>> 2.20.1
> 
> 
> Thanks,
> SJ
> 
> 
I will fix all instances to use tab .

Thanks,
Zhen

