Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B7BD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AB96B00A8; Sun, 21 Dec 2025 04:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A8D6B00A9; Sun, 21 Dec 2025 04:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CA16B00AA; Sun, 21 Dec 2025 04:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E43216B00A8
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:24:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97BD6137C76
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:24:18 +0000 (UTC)
X-FDA: 84242942196.22.DAF3BBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id F340214000A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:24:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6KpgVf6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766309057; a=rsa-sha256;
	cv=none;
	b=0TqyNd2ft3Qr5dcm0hS/c/yazXHuyOQmh1K3FHKp3ueKGiah8xDiCBJ7jP7Q5/6JXStI+F
	7sJh/SgLI1c50gsfTY1qDGD+1kUmwpvp8Plc2V8nLHcTlguYaPfZmN2ZNRZKiZRG9xez87
	QFiYhjwMM9/BhCBplf5Qk79JcXWIL/w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6KpgVf6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766309057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40AzySEFuTplyCO6X8PeDyjzsR9LekCurHo1hfnWFc0=;
	b=THmVciEwdOPvisXSIc2iIUXM/sHrue7D7nNwT15AatJ7u+P7hUBLGdGt9H0QQ2Jtnqfbbo
	w4Rk3I/68o3HjLCuguyt9mnMW6+0owK2OspTg6qXU/Fyq4E9cari9NoJF7FQghGweME1K3
	hjjMZftGMDViznj5rh85hJgl99UiTyg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ADF6419CD;
	Sun, 21 Dec 2025 09:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DBDC116B1;
	Sun, 21 Dec 2025 09:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766309055;
	bh=FE6MAxoF1LdTjoUH1fHFZ697BonNjLX0s2K2Kv4JCys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d6KpgVf6jeLEaHeBi1l0tQJ58vP1PpmzA3dDB5YKVJ5VIQaHiOwydb+YAuGxcQXFp
	 eWCkMTJ8OAilSo0keYxcqx1S4rPDn4hu2utNkrPBHTuZlYPM46N3Pl6NrYtd0tc3Qz
	 82jM0ZyYFyprMUsfiX42/sXwO5KSrPWC2yqnEWPrqQyeN68QZj18RLo57UIGp+mUnL
	 6caLPumhfu5R5Jr80sh9No/MI5FF/Pho8TXdAeewDFMyCsL07/m3U3rE1/pLOJ/4NE
	 +7xpCZsFY0zQVvE/ztZZc9ouMaQqESQmq1ZuVxqNwUP2MPF4vc9+KvWSUTCpqOk8Md
	 Yj4oF9EZVzCzw==
Message-ID: <5af0e0ae-0472-45b8-a249-44b4e5239d33@kernel.org>
Date: Sun, 21 Dec 2025 10:24:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
To: Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
 <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
 <20251221021044.2r5fhepiyyhvuo7h@master>
 <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F340214000A
X-Stat-Signature: ntnuuddg3rdtcwpqjrirye3rnia1faq6
X-Rspam-User: 
X-HE-Tag: 1766309056-511194
X-HE-Meta: U2FsdGVkX19GuKJofTOfQ0jeuAJjZBUJuPMGIsuDy9rK62gSoeVJoJMniYp0aaYthAE0s1NA+Osvu7O9sLudLi8zaw69W8j1S3ioFeH6xaF+zlAcdP33Yu/VJrcQuMT82My3G2piqG2AvQ/3IbRw2zcVnhQUWqYYPWnAVe8cSMbORk8CBmn1mP8ZhlEIWzkkwK/amrKWP5BPjbMjNLZ55MJOL7+lawIKKp0JGMyeb5hCDTmcI+rKsJXhX46WyLPuz5In56DaKi7ziYk8fiaUVIZmGitVxKaNehDxvNxCCQDydvvD1VcuhQbFyFv3MMmblI5DnUU6QYiM8K4KvAUZhZp6rmQLMjmAKMBpCVZin9ElBmfp2WW9FAm44kYFjQdWsV9mMpRUlj5DobxV5EZsaCxNtargacgsvjY4nbSVsiPcOvUdvkGcohfOX8w+L99FAqzRqne1qqx8P+KyVq8X7Gf3W9BRglylxtszC/O5d00QHx7qAd+rEfafzAD4q905wgm3FZuR3PEJY4DTeTYxMjwNkT1cykZF7yW2ZTKSgm0NGpfEbGMLBF7tjBifDr6VFbdPWi5NW5HE6Tjc1xqCSZuKFbvaQfc2k0ZBhF2yw7oXhUTGbNkkoZMnFd8P2JE6iuM0QmXF+vB1ZyOkk54LKcgL/GJhnzl/KDz1YfKsv+336LBOCGuUTmSrLGckPnf0VPHDdYeFO9hS2u2yU5TDy/zwg/57KBzp21c4+Xg5gIrnePezP9NeDA1jNEIbLZFSrrDK8LyfsdyRQ8F5l3od9+/ihpu47wdpHjCyfryHSmk1ZDOra2Bbv9+Za/9eqjOy1wJRL4sBl8PRKjZZ8/UXa2lUjfeXFVqU/99LllafnwpGXROES4hXFcdqNEfCcQFGXocItKE8yYpJomWh4Vo3lDDb7Z8FYbrr482IgswRaEBZmRSqTgKFP7p9cBFgT3ym+2/oulTOOrDtr5IpBvO
 tITDNtNR
 XJoD8GBuWY0OTc9iVt3uQpp5rdFZdJy9CWSyijdsKBP9vhpp/KDZK0oP1YYJTM13pYaq9WKppmfcZBGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 05:25, Vernon Yang wrote:
> On Sun, Dec 21, 2025 at 02:10:44AM +0000, Wei Yang wrote:
>> On Fri, Dec 19, 2025 at 09:58:17AM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 12/19/25 06:29, Vernon Yang wrote:
>>>> On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 12/15/25 10:04, Vernon Yang wrote:
>>>>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>>>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>>>>> continuously access 128 MB memory, while the cold task only accesses
>>>>>> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
>>>>>> still prioritizes scanning the cold task and only scans the hot2 task
>>>>>> after completing the scan of the cold task.
>>>>>>
>>>>>> So if the user has explicitly informed us via MADV_COLD/FREE that this
>>>>>> memory is cold or will be freed, it is appropriate for khugepaged to
>>>>>> scan it only at the latest possible moment, thereby avoiding unnecessary
>>>>>> scan and collapse operations to reducing CPU wastage.
>>>>>>
>>>>>> Here are the performance test results:
>>>>>> (Throughput bigger is better, other smaller is better)
>>>>>>
>>>>>> Testing on x86_64 machine:
>>>>>>
>>>>>> | task hot2           | without patch | with patch    |  delta  |
>>>>>> |---------------------|---------------|---------------|---------|
>>>>>> | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
>>>>>> | cycles per access   |  4.91         |  2.07         | -57.84% |
>>>>>> | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
>>>>>> | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
>>>>>>
>>>>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>>>>
>>>>>> | task hot2           | without patch | with patch    |  delta  |
>>>>>> |---------------------|---------------|---------------|---------|
>>>>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>>>>> | cycles per access   |  7.23         |  2.12         | -70.68% |
>>>>>> | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
>>>>>> | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
>>>>>
>>>>> Again, I also don't like that because you make assumptions on a full process
>>>>> based on some part of it's address space.
>>>>>
>>>>> E.g., if a library issues a MADV_COLD on some part of the memory the library
>>>>> manages, why should the remaining part of the process suffer as well?
>>>>
>>>> Yes, you make a good point, thanks!
>>>>
>>>>> This seems to be an heuristic focused on some specific workloads, no?
>>>>
>>>> Right.
>>>>
>>>> Could we use the VM_NOHUGEPAGE flag to indicate that this region should
>>>> not be collapsed, so that khugepaged can simply skip this VMA during
>>>> scanning? This way, it won't affect the remaining part of the task's
>>>> memory regions.
>>>
>>> I thought we would skip these regions already properly in khugeapged, or
>>> maybe I misunderstood your question.
>>>
>>
>> I think we should, but seems we didn't do this for anonymous memory during
>> khugepaged.
>>
>> We check the vma with thp_vma_allowable_order() during scan.
>>
>>    * For anonymous memory during khugepaged, if we always enable 2M collapse,
>>      we will scan this vma. Even VM_NOHUGEPAGE is set.
>>
>>    * For other cases, it looks good since __thp_vma_allowable_order() will skip
>>      this vma with vma_thp_disabled().
> 
> Hi David, Wei,
> 
> The khugepaged has already checked the VM_NOHUGEPAGE flag for anonymous
> memory during scan, as below:
> 
> khugepaged_scan_mm_slot()
>      thp_vma_allowable_order()
>          thp_vma_allowable_orders()
>              __thp_vma_allowable_orders()
>                  vma_thp_disabled() {
>                       if (vm_flags & VM_NOHUGEPAGE)
>                           return true;
>                  }
> 
> REAL ISSUE: when madvise(MADV_COLD)，not set VM_NOHUGEPAGE flag to vma,
> so the khugepaged will continue scan this vma.
> 
> I set VM_NOHUGEPAGE flag to vma when madvise(MADV_COLD), the test has
> been successful. I will send it in the next version.

No we must not do that. That's a user-space visible change. :/

-- 
Cheers

David

