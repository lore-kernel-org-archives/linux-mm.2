Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B88ECD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705036B009F; Tue, 19 May 2026 08:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADD86B00A0; Tue, 19 May 2026 08:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C46C6B00A1; Tue, 19 May 2026 08:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47BCE6B009F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:16:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 125C5402BF
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:16:00 +0000 (UTC)
X-FDA: 84784066080.24.4B989EA
Received: from mail-m82108.xmail.ntesmail.com (mail-m82108.xmail.ntesmail.com [156.224.82.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B9EB18000C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:15:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KqdQ1bISy0Q/QqqSLZKlA2u5r2bHaILZF6tTdAeE3NM=;
	b=kqBL6irvV36f/Ca8D1h2SkoWTzr1KO8CV8Fcce0boeFstCrWdgVajUQh1d5MCC8sKVFoDd
	nEodFtOlSg5GuUocUHprMoLoJ8RQzpvuVE1TON49NCEn51UajhHmeB4vKneP7U4vLxBXQY
	aaZIlHunx6umYqKZMZMfMU6OQFFEtDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192958; a=rsa-sha256;
	cv=none;
	b=nTIKuFYkKTbDHu6gGwrUj7z3AscuU9hd/Trp/5Ilq04thDlsqKH90G26IE7u4DFkrg+z7J
	ZRhCXYyIckMkb9LqvVi2czZgmvrMRLZJEEHrHWcl5ZrfaaA1ei9NOtkN0mOAxeOKWc2tRM
	yB5NNspg4xAcZ0jsgoK13AK5tn1ezIM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a528746f;
	Tue, 19 May 2026 20:15:52 +0800 (GMT+08:00)
Message-ID: <5b3c8707-a37a-4cec-907c-64618c246963@easystack.cn>
Date: Tue, 19 May 2026 20:15:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org, vbabka@kernel.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
 <35bc8518-27ee-4c6d-8e62-208b35e62c80@kernel.org>
 <f3ea1493-3447-4510-b33b-4b27c148b657@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <f3ea1493-3447-4510-b33b-4b27c148b657@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e4029f5fc0229kunm041c7a1e3293
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHh8dVh5NTB5CGE4dSE8aS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B9EB18000C
X-Rspam-User: 
X-Stat-Signature: ac766dtfojwtsmqakj8y3nn5f6pk8wje
X-HE-Tag: 1779192956-620255
X-HE-Meta: U2FsdGVkX1+k9dUbH08pJf2h/0jBNU3xm53ig6xLp+8XTRZK5/G/5ygCPxAPwJ74V3KslajeqKzFqRVByd8lO8kcUqrviUEYGUxjEcz2IbM9LEEv9dC68WSJxoaUyKgD/EjfOy236xPKgkykInaKK+oFq8n8nWr6reSkdliOUH0TMsmUEghnmmqcNG2uFcHTSFWHKW3W4zudorVdbakPKYYUnwXC2/dDyrvq2Ig+pWW+Zl0+4GIoI28q2NQvEP3cCXwu2U44nxoogjsAeGWoF8wV2aS5lz5NNFA5jtLGHwBSilDxQ8ud+K7CZdz8aI83Rm3XcNgE8pdpZInBBZJgfJBltX8kxd6hXxYi2BQS/vuYg18OhEOeVzE0EREyuSHcN9+LB73f/ph90GN0cH/ig9n1HVkbK3wmgasdFNdjDI1XvuI9rBgieUxEUgC9uSeGh2UpGWa5TK14o3AWgiDoDHCwU/GDMg4fCyh2cbnUb7/SFiBuxqLI19OX82Op9GTjKSTClWXPUgmvixZXxa031pYDpOUUDXgLwhuREUiTeA8grhHTdPRqbKn7tIXBWYyDeiM95fSojIXArwH60uAaKYbQ+Cb8DnjE03HdrNJyfymsYGztZXlVQU22JhTS6npOe4f72ODr9wgeDpBcOYeEeBySb+7dMwkRn+Ptp7apnWaaxqNc4pvKasvS4sdeZT3y4Y5IhxHNt/ZqUmnX+FxfIp5FF85QzykyVXGw6kP2Ib4Ly122GYWQF6rG3Ov4EDat9bjM7+grRXGAePTJ9Uz/S6CPjLS05dN8L9Z/jy0tj2pZ82OsmKPU9WQaQk38sP/ZFR/cJ31MfvkhuhnOjhBtNkA8GrIZczM7f9bBKZ51MTaJU04dCFnV7PvaAFAmgylv/dkZaPdP8l6FS7SlUK6nmxC7EKsztvqJLeci/S8MYno8xCIqgPtQ98YafFxIEoS/wumdh1iW56Y8qaIg8A2
 g8SLFTcZ
 kavSXmT3uSVrX1zOZIDew6N0r7CtBiOd4grfnrhM02zohsA4EYFDOkImaUh4NnkWPn2b51Szi0btR000JINOt6bFoZKxZNH92HxjEeqIwzDtgGwAjNn7ByT/6W3VtTkM5usz0tjxnP0RjWA6X1HjIuRkMxWpEs9AJzMBfHhlrE6Ry8upNBRB9KFdoSeR65Qt+uGSJKGkKrXLULdpf9OCJRRkcOndAu0I9PJD3RMsf07SLeAOjTdqtrb/cppq7GpUU+4WWBapOJc/CSHZWsSHz2t3HoI0p39Kx+0CSpAGfWMwhH5huZAt7EeAwiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/19 09:54, Harry Yoo 写道:
> 
> 
> On 5/17/26 9:49 PM, Harry Yoo wrote:
>>
>> On 5/15/26 6:19 PM, Zhen Ni wrote:
>>> This patch series introduces per-file-descriptor filtering 
>>> capabilities to the
>>> page_owner feature.
>>>
>>>
>>> Problem Statement
>>> =================
>>>
>>> In production environments with large memory configurations (e.g., 
>>> 250GB+),
>>> collecting page_owner information often results in files ranging from
>>> several gigabytes to over 10GB. This creates significant challenges:
>>
>>
>> Just out of curiosity...
>>
>> What are you trying to do with this data on production servers,and why 
>> the existing
>>
>> per-NUMA statistics don't work for you?
> 
> If what you want to do is dump which code locations allocated how much 
> memory for each NUMA node on the event of OOM, you probably want to 
> improve memory allocation profiling instead of improving page_owner 
> functionality.
> 
> IIRC there was discussion [1] on supporting memcg and numa awareness
> and querying using ioctl().
> 
> [1] Memory Allocation Profiling upcoming features, LPC 2025,
>      https://lpc.events/event/19/contributions/2146
> 

I want to identify which call paths allocated the memory on 
nearly-exhausted NUMA nodes. Existing per-NUMA statistics (such as 
numastat -m) cannot tell me this. For example:

	# numastat -m
	...
	MemTotal               256923.12
	MemFree                214873.33
	MemUsed                 42049.80
	Active                   9573.74
	Inactive                20694.62
	Active(anon)              876.71
	Inactive(anon)           1161.75
	Active(file)             8697.03
	...

This is particularly problematic because I found that a significant 
portion of NIC pre-allocated ring buffers are not included in any 
numastat -m sub-item. This makes kernel-directly-allocated memory 
difficult to detect using conventional means.

The most outstanding advantage of page_owner, for me, is its ability to 
traverse PFNs and print information for all pages along with their 
allocation call stacks. This allows any memory that is difficult to 
detect through conventional means to be captured by page_owner.

However, the large volume of data and repeated stack printing make the 
output very large and difficult to analyze. This is my original 
motivation for introducing the filter.

Memory Allocation Profiling is designed for low-overhead code tagging in 
production environments, and its information is relatively aggregated. I 
believe that even if it implements NUMA-specific filtering, it is 
unlikely to include stackdepot-level information, which is relatively 
heavyweight.


Best regards,
Zhen Ni


