Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2DDAE6F07B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CAB66B0005; Tue, 23 Dec 2025 04:59:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2976B0089; Tue, 23 Dec 2025 04:59:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D95C6B008A; Tue, 23 Dec 2025 04:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 294986B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:59:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABCF8140111
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:59:37 +0000 (UTC)
X-FDA: 84250288794.09.E4652B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 12FFF1C000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:59:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3kkAboY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766483976; a=rsa-sha256;
	cv=none;
	b=LQklwBZfoNNa+7U/cctl3yupynVjHaXMMvIZkyBCn/QB7ZDM0khf+m6EFsmdJY7m+vJz8V
	4ctOchNrZtG5b6Rfk3K3glGZZRmT5W96wmuhCGYBew6ZCtwnAyr1l2M5nM3QaDiN5dFXmD
	+QUfujlAcL/70kk1zfwIsBICnrJd3Os=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3kkAboY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766483976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbLv6DEHgtDaX0O34tA7+y6ZTkgWpq+kPJwsCYukxAg=;
	b=8oi0O5Yo99gIeOAkF3XIMBLPJZ2I55m3fkbQ3v9nAtcOWxGDdIN55vWM+LlHaN1cBz4+hI
	nXWdwUL4onyRh9TtDLOkIrJ+0AQzlMkrOVzyRb6XA1Z5QUgnZkkWy/LjbqvGjTAx0rNB9N
	6xLK0LKttOW+YYsa9VTKeB8ORhuYYjI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B45140659;
	Tue, 23 Dec 2025 09:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA1AC113D0;
	Tue, 23 Dec 2025 09:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766483975;
	bh=iKMg2CO9oQKKaDz/ACI08ogERjb2hc2nhBYRMS9mJCY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a3kkAboYgw5haeZSBviuhS3C0XusEuKN9e/Ax+iBOiGqbpvVbosS2sP0DcEtDEoYR
	 GPSOIPboBTwkTdft7V3q8FzP0tj2gOMTugewkjCePWSnhajgrDN/1Fklyxc2gAj0QZ
	 LxivIjGOgsiXeVtLL3uVvZLVudaqXcD6+oqJz2STkNwBIXabm51VbRvNdmJZi1JGsb
	 Dp8DsqwlNwcLSHq6xPvJ/JY+Ng5Eu+Q45XuhPVA3dMYpdMmqOseV8NPlGSR56w2JFM
	 sNyL9qg/cQtg2mtMVzWzhwbjU5B66LOAfdEnCL9PfBWqk4BX0bJzr9dgPth4eqmfz1
	 F/8AXxUc5jHkg==
Message-ID: <ad2c1355-be13-45d9-8474-a32a4b710aa5@kernel.org>
Date: Tue, 23 Dec 2025 10:59:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
 <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
 <20251221021044.2r5fhepiyyhvuo7h@master>
 <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
 <5af0e0ae-0472-45b8-a249-44b4e5239d33@kernel.org>
 <ck5nkriyqdvy7ftu3xeu6cn4aj3s3cpefbga55vkzblnoywrpi@2sw5oh3saixt>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <ck5nkriyqdvy7ftu3xeu6cn4aj3s3cpefbga55vkzblnoywrpi@2sw5oh3saixt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 12FFF1C000B
X-Rspamd-Server: rspam10
X-Stat-Signature: cu9pq4r6f1ye8ty9ae8nx9dik1fqhtx3
X-HE-Tag: 1766483975-103120
X-HE-Meta: U2FsdGVkX1+E7YUNkzMog/rl4uFwFi04OAj+g8cI9Mm3Udmiwl07DTFPY+6DBPy/NAb+QTRKwd2ADZHUtcE6Du/aXllry7l+U7NcFkMW4aonfIReOX1odcgkZ1PyCT4NBNyxWg210XXxmHzsig9YL06nSDyFRXj8J4nl5FQqz3/vvrkJ2yUCmfg/WkSXqR6yNAse6Lma6UGk+vtfgTtcAQlm+aB4LUhO8BKGIHqGXFVqdZmc4j8dlzvGUrgphKZ75syAkooicw64AhoAMLpC0SILc9RYiQ7wPr7z5SsM5ghqlnm7+Qs8nTxO/H41RUzwhF32cPtNn+4+JdlHvO2Ms27JVKdG0wGyHBtuCQXbx43u20tJQeKa/8ZDQTMc7K2Bf3/kbv5ZLsjTKTBXCVlokLIoEFa3a2M4IourURuNEIEMfFKoeUhh72w/CXokgYGmIuVLqOb/JcrzZxdVc0Ov4oDIfI+1qtsVFmL1EF2UQ7u9XRPW+Y5hDIt+MX6ggc6GQA/YJkMXfXI0tJGbW7DOT446JXJO7VRDRuaDfHMvE8pmZIpusq1fSGPYxsrasnDdlppo8H6Ts7GI107TVLIh3RNna0C75ktC6s2RL8GzFFg0vqkdM69DBnn45gz13dACc3nvm1Je2ZCEt28PIbyfxHoFbJe1RKlEWeHxsuFbLNU6xmRkdY5TXZLT7ia+2ktB/9OtTYUzEgysZR/SVjhBbYIgEQFzO6DcJToDSUZnmksiOFd6kftqnh7hXJYoIS+oeaBBNUbwhs9oYeTCPvUOEHyRYMUDHfWDPU8LiJSXI4SzfbytqDjotfb+uYbuaLkaoOVx93s4vI+7s3D1Ynnu5wr/yiu7BwWyFvqERVne2xHGEZRDhakVtr2/97tPWIDGuZ3nbFDUOwmunKHkZsHuP8m1t8cCwboe8IqZ+b6oW9FJS0CJ+v0VKm/zjmlJ2QjGp+fzEtBr72WJAcD48h+
 0DrdOCmJ
 C4499mtsyIv48v0WWRUteIQumqatsif4jIYEMG5BTtDn/zK76gQtZauNLMaIwWJC8ukHTqMiilrSzb1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 13:34, Vernon Yang wrote:
> On Sun, Dec 21, 2025 at 10:24:11AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/21/25 05:25, Vernon Yang wrote:
>>> On Sun, Dec 21, 2025 at 02:10:44AM +0000, Wei Yang wrote:
>>>> On Fri, Dec 19, 2025 at 09:58:17AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 12/19/25 06:29, Vernon Yang wrote:
>>>>>> On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>>> On 12/15/25 10:04, Vernon Yang wrote:
>>>>>>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>>>>>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>>>>>>> continuously access 128 MB memory, while the cold task only accesses
>>>>>>>> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
>>>>>>>> still prioritizes scanning the cold task and only scans the hot2 task
>>>>>>>> after completing the scan of the cold task.
>>>>>>>>
>>>>>>>> So if the user has explicitly informed us via MADV_COLD/FREE that this
>>>>>>>> memory is cold or will be freed, it is appropriate for khugepaged to
>>>>>>>> scan it only at the latest possible moment, thereby avoiding unnecessary
>>>>>>>> scan and collapse operations to reducing CPU wastage.
>>>>>>>>
>>>>>>>> Here are the performance test results:
>>>>>>>> (Throughput bigger is better, other smaller is better)
>>>>>>>>
>>>>>>>> Testing on x86_64 machine:
>>>>>>>>
>>>>>>>> | task hot2           | without patch | with patch    |  delta  |
>>>>>>>> |---------------------|---------------|---------------|---------|
>>>>>>>> | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
>>>>>>>> | cycles per access   |  4.91         |  2.07         | -57.84% |
>>>>>>>> | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
>>>>>>>> | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
>>>>>>>>
>>>>>>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>>>>>>
>>>>>>>> | task hot2           | without patch | with patch    |  delta  |
>>>>>>>> |---------------------|---------------|---------------|---------|
>>>>>>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>>>>>>> | cycles per access   |  7.23         |  2.12         | -70.68% |
>>>>>>>> | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
>>>>>>>> | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
>>>>>>>
>>>>>>> Again, I also don't like that because you make assumptions on a full process
>>>>>>> based on some part of it's address space.
>>>>>>>
>>>>>>> E.g., if a library issues a MADV_COLD on some part of the memory the library
>>>>>>> manages, why should the remaining part of the process suffer as well?
>>>>>>
>>>>>> Yes, you make a good point, thanks!
>>>>>>
>>>>>>> This seems to be an heuristic focused on some specific workloads, no?
>>>>>>
>>>>>> Right.
>>>>>>
>>>>>> Could we use the VM_NOHUGEPAGE flag to indicate that this region should
>>>>>> not be collapsed, so that khugepaged can simply skip this VMA during
>>>>>> scanning? This way, it won't affect the remaining part of the task's
>>>>>> memory regions.
>>>>>
>>>>> I thought we would skip these regions already properly in khugeapged, or
>>>>> maybe I misunderstood your question.
>>>>>
>>>>
>>>> I think we should, but seems we didn't do this for anonymous memory during
>>>> khugepaged.
>>>>
>>>> We check the vma with thp_vma_allowable_order() during scan.
>>>>
>>>>     * For anonymous memory during khugepaged, if we always enable 2M collapse,
>>>>       we will scan this vma. Even VM_NOHUGEPAGE is set.
>>>>
>>>>     * For other cases, it looks good since __thp_vma_allowable_order() will skip
>>>>       this vma with vma_thp_disabled().
>>>
>>> Hi David, Wei,
>>>
>>> The khugepaged has already checked the VM_NOHUGEPAGE flag for anonymous
>>> memory during scan, as below:
>>>
>>> khugepaged_scan_mm_slot()
>>>       thp_vma_allowable_order()
>>>           thp_vma_allowable_orders()
>>>               __thp_vma_allowable_orders()
>>>                   vma_thp_disabled() {
>>>                        if (vm_flags & VM_NOHUGEPAGE)
>>>                            return true;
>>>                   }
>>>
>>> REAL ISSUE: when madvise(MADV_COLD)，not set VM_NOHUGEPAGE flag to vma,
>>> so the khugepaged will continue scan this vma.
>>>
>>> I set VM_NOHUGEPAGE flag to vma when madvise(MADV_COLD), the test has
>>> been successful. I will send it in the next version.
>>
>> No we must not do that. That's a user-space visible change. :/
> 
> David, what good ideas do you have to achieve this goal? let me know
> please, thank!

Your idea would be to skip a VMA when we issues madvise(MADV_COLD).

That sounds like yet another heuristic that can easily be wrong? :/

In particular, imagine if the VMA is much larger than the madvise'd 
region (other parts used for something else) or if the previously cold 
memory area is used for something that is now hot.

With memory allocators that manage most of the memory in a single large 
VMA, it's rather easy to see how such a heuristic would be bad, no?

-- 
Cheers

David

