Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32EEFAD3E5
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 00:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F276B0005; Wed, 22 Apr 2026 20:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFB86B008A; Wed, 22 Apr 2026 20:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5AA6B008C; Wed, 22 Apr 2026 20:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACCF6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:43:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 320328B5DE
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:43:57 +0000 (UTC)
X-FDA: 84687973314.16.4873090
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2D24C000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:43:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NaoqSQdH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776905035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6T3PCwJfjQMPBIXiRKansmxy8djAFUMHOTBn4vItwGw=;
	b=eXydOZewiGjFmal+RpYrrk16+ENuuJEgJOar7jQYf+qLnj2FddRtV2Udk53YOV775uJxeq
	jhgVMDvdW1fWpLAYWqxnbdFE72dYkw7FxrFvYao9MQaU9/eqvkxW10vkjwwVLwibZxYBVS
	jO7khdBSl7BjsbPrgxLQ8Op0viSnIes=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NaoqSQdH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776905035; a=rsa-sha256;
	cv=none;
	b=2T8iNqUuhZsKAEIzWOWfa69nYqzJjnudbIO9CujsgMgr8FPOWOTN4vOzW2B0vJHWxd8/gh
	3+llq5fVvNAIvKqcyi5UPYl4srgWR+GIVT9vq9z1gCZQ+V+IAQ54I7sFuDU34wHvSTnSw5
	Gh8JJjOnS8u2SMoWshrQLyGKKmIQwOc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776905030; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6T3PCwJfjQMPBIXiRKansmxy8djAFUMHOTBn4vItwGw=;
	b=NaoqSQdHTr36pqfnYNCbJ65Uyt7w1dGWMSy1V7UIs6SiFjEim4S0nhiOxGG+dZRnes7ijyw2zVIRqRdBUHjoehWxOB2CT67i6XHc0u6uwNGABgE7J3MhaVGVg92YfuP9tM2Z/25gd44Dpo+Xr9jFaXir6iEDDiULPGHxV+llW0E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X1XkNlW_1776905029;
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1XkNlW_1776905029 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Apr 2026 08:43:49 +0800
Message-ID: <73d1150f-8eea-4523-8d29-335f91d38e1b@linux.alibaba.com>
Date: Thu, 23 Apr 2026 08:43:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
 <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
 <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
 <07e26d39-6155-4661-b3df-c2419535ed43@kernel.org>
 <f9508e75-789e-4eb8-b09e-b66a8676a6b0@linux.alibaba.com>
 <bea6080a-850c-4b3f-bcc0-719efc372e72@kernel.org>
 <116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com>
 <12bdade5-b239-4456-bb5a-f2648c867db8@huawei.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <12bdade5-b239-4456-bb5a-f2648c867db8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D2D24C000B
X-Stat-Signature: d8ybr1zoye3fh7ff3q466edkxmjmfycj
X-HE-Tag: 1776905033-875196
X-HE-Meta: U2FsdGVkX18B/lOOlcz7TyvECdmZ/N0rPp5oQBq6aRZBxxk4A2DHUq4ml+w8gbucT+D/UMKrAymyqMluqJTJhvRmok9afMIL6DPr5uXfozOh90lUFlNCisnn9Skw+Rr76Wg6AdZWu7pX9pMwVH/LF5yqJoYe/oULIHbbEUubdUl8uDhSysaGRxhDyeM4JaCFq6mxNp0xmAwXMDAVihSAncpiyxAxt/vfNck84n8HNS3o9dJyDqhm2snBRT18yFzFA6DUDOvTbx7I0Xm9N+K3lv3eHEFOeV+6VejPaVi7gAF41EeX18RZ6RsRcK/2FsKRSs1S5Fh0jSCuJKx5w4dZfVNzTnK9ERdNM9SggCTBKEFlhdvya+Quj4ICZRWvL/yJgtXa5eYYV+OMkOhHcG9mC2UUyanQx8ajY9ofnifB47iSDCoumw3CMMduXlPDzkNO8DICnZSm8pdq1bxaEWX5pBL95OMyXIJOpol9eXSMW3E5u47u+Bws7eHhFINSHKw8sBgY0Gi7/87JRjcE3OeCSqAaJarSe/UeG+uBzBDj2qOnhhT+SvCaR6H0AaiMlx5oMCTTbLYZ7ebNxjDypjTPopsHDHBhZhOLh5V7DJaeDZXaKGYjzzL+ZS//nWo+bpv4wLIQnCmt1f9r57M1Rk1wqdifjViXQY+gwiC/ZKgt5DXE5X+9ZptVYdXgPwqq5kWpc6f22rd0ecPHHf9Tm1g1x9JEkXLBAfFbUyYZyKkHLnfFl8w4dE0y43NxJ9ZmCpgT+AUaMC+HULVwsHxThDRpf6GjMNKwy9hOkDW8vjAANW+X1wH8LC7vm1u1IX9GCf6KJ61hRa2ac4rMmmSyp/rfr0ectIfrZD1BJttNQIW64mdx2qFpf9OqQFANObZgIV3oA92UPd98P+5m/N6ZxdVg3i2hCVbWOguxSNIUxkJUTqa1Set2UY1NpVQkvg8kxzzRtzkm/sBdP9eSDlhO7g9
 jZ3vJiTv
 MeEJIt66a+QBoBjPkN8In8BlN0ETDzJSZLiRaLC78HFKYGHn2ElJGtB0APjXM31yP9AXRXze4+b7/pDVubp1fEumG3cAXH6k51YqcMAK17RWEzNq17gSGnZdozVcmmbHmvmZhNLjhlXEkrkdogxka/A7jfpBKejVV2L+/go9izAH1HaEnSHsL6VY25MRT+kXYJWKZ2h6C4DlezuvjrKmnihQ+oEFltKXTq78TfXZYdSXhaa6vPquX6bqgPeupL6n3qjwaA3k9TbHk83IpAapBagnPhjwaKGqiOypz4Zr+B7Qu+YEOQ4Og3NTSgvxdOzK6WZjfxCbf/Olurwu9eJ3Vkw9qebrcRbjU3cDT2RPi4v78Nx6GlHnteXs/JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/22/26 11:03 PM, Kefeng Wang wrote:
> 
> 
> On 4/22/2026 2:28 PM, Baolin Wang wrote:
>> CC Kefeng,
>>
>> On 4/21/26 9:39 PM, David Hildenbrand (Arm) wrote:
>>> On 4/21/26 08:27, Baolin Wang wrote:
>>>>
>>>>
>>>> On 4/21/26 3:00 AM, David Hildenbrand (Arm) wrote:
>>>>> On 4/17/26 14:45, Baolin Wang wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> Indeed. Good point.
>>>>>>
>>>>>>
>>>>>> Not really. There could be files created before remount whose 
>>>>>> mappings
>>>>>> don't support large folios (with 'huge=never' option), while files
>>>>>> created after remount will have mappings that support large folios 
>>>>>> (if
>>>>>> remounted with 'huge=always' option).
>>>>>>
>>>>>> It looks like the previous commit 5a90c155defa was also 
>>>>>> problematic. The
>>>>>> huge mount option has introduced a lot of tricky issues:(
>>>>>>
>>>>>> Now I think Zi's previous suggestion should be able to clean up this
>>>>>> mess? That is, calling mapping_set_large_folios() unconditionally for
>>>>>> all shmem mounts, and revisiting Kefeng's first version to fix the
>>>>>> performance issue.
>>>>>
>>>>> Okay, so you'll send a patch to just set mapping_set_large_folios()
>>>>> unconditionally?
>>>>
>>>> I'm still hesitating on this. If we set mapping_set_large_folios()
>>>> unconditionally, we need to re-fix the performance regression that was
>>>> addressed by commit 5a90c155defa.
>>>
>>> Just so I can follow: where is the test for large folios that we would
>>> unlock large folios and cause a regression?
>>
>> I spent some time investigating the performance regression that was 
>> addressed by commit 5a90c155defa ("tmpfs: don't enable large folios if 
>> not supported"). From my testing, I found that the performance issue 
>> no longer exists on upstream:
>>
>> mount tmpfs -t tmpfs -o size=50G /mnt/tmpfs
>>
>> Base:
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>>
>> Base + revert 5a90c155defa:
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>>
>> The data is basically consistent with minor fluctuation noise.
>>
>> Later, I continued investigating and found that commit 665575cff098b 
>> ("filemap: move prefaulting out of hot write path") fixed the write 
>> operation performance.
>>
>> Base + revert 665575cff098b + revert 5a90c155defa:
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.0 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (2.9 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (2.6 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (2.6 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (2.5 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (2.5 GB/s)
>>
>> We can see that after reverting commit 665575cff098b, there is a 
>> noticeable drop in write performance for tmpfs files.
>>
>> So my conclusion is that we can now safely revert commit 5a90c155defa 
>> to set mapping_set_large_folios() for all shmem mounts unconditionally.
>>
>> Kefeng, please correct me if I missed anything.
> 
> Hi Baolin，I found my testcases "bonnie Block/Re Write"
> 
> ./bonnie -d /tmp -s Size (size is from 100,256,512,1024,2048,4096).
> 
> But the dd test is similar as well, and as commit 4e527d5841e2
> ("iomap: fault in smaller chunks for non-large folio mappings") said,
> the issue is,
> 
> "If chunk is 2MB, total 512 pages need to be handled finally. During this
> period, fault_in_iov_iter_readable() is called to check iov_iter readable
> validity. Since only 4KB will be handled each time, below address space
> will be checked over and over again"
> 
> But after 665575cff098b, fault_in_iov_iter_readable() is moved, so the
> issue should be fixed.

Kefeng, thanks for confirming.

