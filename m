Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA8CEE642F
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 12:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC5F6B008A; Wed, 31 Dec 2025 07:20:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4BD6B008C; Wed, 31 Dec 2025 07:20:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0956B0092; Wed, 31 Dec 2025 07:20:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A00886B008A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:20:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AA51BD51C
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:20:07 +0000 (UTC)
X-FDA: 84279673254.29.962E6D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F94180007
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:20:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKkssGvx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767183605; a=rsa-sha256;
	cv=none;
	b=HabljVEHzPQfC+LNz6ZaJY0jbTX/LRyWpHigyx7m1H3Vrp4rV4PMdo8fhkadi8NYsGO9EV
	qrGFKeWq/hvO9zUlKQGEAf4KhsopReH4ddQFt0myl7joUKVJgF3110N7PIpNJv4YiUKRs3
	jhZwDAsqHk1AoT/eL6bl63rCdOibf+4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKkssGvx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767183605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sw90aRybcPV/B8SZmlG59V+Ru09DlutxsxmW/VhXne0=;
	b=JnOVy6FnHj7gfoIi9e7shFAznfTio3lRMINACbW2AJZuTE2Um3LUYtqmBZbq/IUuP/Pm4b
	C8UNTJOkH8ad+Z9XlqVFOeQNsWnbFH31RXq+bc2LpH79FnsTp4ZBTnbgTEIio6qCU9Un7Q
	bDvAzit29tE+KcWvy5sR/xOIKH/2D7k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46ADF438AD;
	Wed, 31 Dec 2025 12:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84223C113D0;
	Wed, 31 Dec 2025 12:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767183604;
	bh=6JsT0Go9bhDpDyQcmpzezbZhJaAg0PltAhVOKwaVUD4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sKkssGvxd294VQSOv9dbIgBsZ5gnNDW8sQAHO87WrhIzCaGWNzPJjebTtgBldRiha
	 3xbMVE3RaZgZN8FKgIA/sLKQ7qHjuWdjsVeS/DcxhSMS1xnKtB8HS/XUVZlHUIrgik
	 FHrlvEghIcrbJ4NiiOwQYS5WaAhLc6Gl/vh4Y1+n/vGZyKvQxEu+SvfOIcBp18R04Q
	 gzAE9QWCZk8VzhHdyUcs0pyeyIq+klYl5RM7Oor8hexeUq9P3T/XqV7eU3YGZkP4mE
	 xORreMXlABl5lkG6iVumdxpWLTTJU08WixEzahmpcGjlhYGYU3Hi0UhFBa2YSgwyll
	 vQJc+fKCHOirg==
Message-ID: <cb4bf737-a5c2-4299-833a-5075ebdd0011@kernel.org>
Date: Wed, 31 Dec 2025 13:19:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when
 MADV_COLD/MADV_FREE
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-4-yanglincheng@kylinos.cn>
 <084eee6b-6c9e-454b-a563-b2babb76b099@kernel.org>
 <4y4aht35lkswkaorr36m6276aktp65bywdtnj6sxo7koscj3qp@qpdjv47lc75v>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4y4aht35lkswkaorr36m6276aktp65bywdtnj6sxo7koscj3qp@qpdjv47lc75v>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F94180007
X-Stat-Signature: bu1o3rpouf14nfmbehppfw5pgm3mqam5
X-Rspam-User: 
X-HE-Tag: 1767183605-853227
X-HE-Meta: U2FsdGVkX1+JrPxmmggEsysGp6iiLKlvQ8bEhGZP4SJA0VI710OQtyW+6idbdEPo/CIF07hilKrYbm+DTbtHvYZfHHdVgXP60p3DNHWXC6Fv7rRVaalgI+PNg6G1WN3YKeXlyc7EU4uaTDh3Mx1Rk+c0r50tpH6LTqYlWPixuR9hQNnXAhvO8/3Oz1H/vGWMHUORSpcQzD+jXheWnE0bpSaPYUUrgG2VPQ5ZRrQik4QxidPUy731c6VhnAzVeC7o2cMJUJ5rQyGnz/l9qtIJO2Yyuukdpzi2O4U3nK4p2p0DLmpaPYJI1EGbYD+NCtdVAlal8eD4fJiDvmObN6w9oO92OVrSP/tAY//35KbNHYr7lwnh6EWRJVzVZGNET3/HcT4hcCeigN2eUFEgAtr6FPtebCW8pgpodqVVoubjySgh3Fp2qxykEVRBUKnAtN2ah64lQpUs8/0OS9ade1eeqpnmuERfjLZyKaXNjxU33kyRVIGTULoHsD4vOvlt3pUpxt0W1bjquOY6LFD9sYZqMV4KhSq4ZaxHOhMR945A3ZSQFCbwI3UlhnLE4Xu/qNenc5rcGoLByNRotNXGMrmOkGWZoJEWcKct34NzIme68BkNqMCOuQ0YXetADasTk0EthSwwfWruV8eGbJqSH7SpdE13LAqzXRtyjeftz+8ZOhuGaih8zNtAid8M6UOvGSW88LULn+gBuhdE+3toDvVtTOPr94TTdWgPmoFM5lQUZCLeyOyzIHI+gbmFOM4673SfPAXp4BDEoL7NwJYlZ81/vQku8UM2xheE1YQCnNp69hMmGe7RnuGEjvmT9l7qVi6gLFwh6lvizg89RwMKZzg6DH3OkZv85a2C/a9UoSe/gcfjEzWdbXjWgdj/g5AOnUxTGs7S+eedByXJfe8/ogO4LOEaAgmDbYXNOshLIi9df+ou4WBjlb8l9fyTAnfi147WnvnOyroIbEZWFtTGx2S
 UnT7jDvM
 c3u1lBYe0wqpCCH/RDaOwWJ5cNBahAMIx11xji9+2HbSR4UgO2zapFeYffp54Mewsnp5ruDCY0JgMG/BRMwfhnNcfa8F3aIQJN201PJo7TjWLnD4Qne3mOuug5htwj+0XgQp0d/4t8kQd3pzZjodcOxvp/RXovFx+7OZNSzvsDskSIx1kY6MrgN9KpN+j0ovyr4IHIh8TeJJf8eHv53bkiFswoZKmeHxDo/CETxsFWr9cSm0k4Nny3f9XvspkD0NIdXJMK2CvmHyWDKGODXRi3u5cBXMhjx10W/KPpVtqOZYepgBdMVEnfb16bsvx5Kr0wQW8jZe5NzZrKwiNWq7wDT3JsG5tgSu6p8bpFE0FEXxbq6tiISbXZVX4NT8WWemQxB/Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 13:13, Vernon Yang wrote:
> On Tue, Dec 30, 2025 at 08:54:33PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/29/25 06:51, Vernon Yang wrote:
>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>> continuously access 128 MB memory, while the cold task only accesses
>>> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
>>> still prioritizes scanning the cold task and only scans the hot2 task
>>> after completing the scan of the cold task.
>>>
>>> So if the user has explicitly informed us via MADV_COLD/FREE that this
>>> memory is cold or will be freed, it is appropriate for khugepaged to
>>> skip it only, thereby avoiding unnecessary scan and collapse operations
>>> to reducing CPU wastage.
>>>
>>> Here are the performance test results:
>>> (Throughput bigger is better, other smaller is better)
>>>
>>> Testing on x86_64 machine:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>>
>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>
>> As raised in v1, this is not the way to go. Just because something was once
>> indicated to be cold does not meant that it will stay like that forever.
>>
>> Also,
>>
>> (1) You are turning this into an operation that will perform VMA
>>      modifications and require the mmap lock in write mode, bad.
>>
>> (2) You might now create many VMAs, possibly breaking user space, bad.
>>
>> If user space knows that memory will stay cold, it can use madvise() to
>> indicate that these regions are not a good fit for THPs.
>>
>> But are they really not a good fit? What about smaller-order THPs?
>>
>> Nobody knows, but changing the behavior like you suggest is definetly bad.
>> :)
>>
> 
> Thank you for review and explanation. I got it.
> 
> For MADV_FREE, we will skip the lazy-free folios instead.
> For MADV_COLD, it will be removed in the next version.

Just to be clear, setting VM_NOHUGEPAGE should not be done from any of 
these operations.

Treating lazyfree folios differently in khugepaged code could indeed 
make sense.

-- 
Cheers

David

