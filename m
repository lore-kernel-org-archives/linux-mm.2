Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3BCC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5837B6B008A; Mon,  7 Sep 2026 12:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534AF6B0096; Mon,  7 Sep 2026 12:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4242A6B0098; Mon,  7 Sep 2026 12:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1FBF6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:08:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F2FB1A01D2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:08:41 +0000 (UTC)
X-FDA: 85187449242.13.B9E58E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 906194000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:08:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=caUN+MPf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGMn5/9sC/zi2FVSWOrMUOQZ1VDAtU/WgF3coPeOhVo=;
	b=fhHrjgdxlsspsy90zhXjhEwvcoshJQSRgMRPpYv4meVP1twdlAyd+9a9bgbg9luSKWSqsu
	wlxxSMQsLShf4Rr6EYYZ2tBJjtMdE/LiLFilef7uQ1fIwgbadLCMkDWFpuR1lC0oAFFavX
	BMXncIYMlwTa4QFr+v4Y2x8WLw1fuEc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=caUN+MPf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797319;
	b=ZZyVRJEZLe6z1BhKxlz+7atrGv2+d2Ps/PFJ22vf6490rbMReTn78YDSlHwRpMRpUQrRT4
	tuh3XCIq3IMYiGtiB0G28lvHyUivUm9pOD7lxntuVnKBIio9FOZew67Eu93fstk54FatNM
	hCqQtAwoK96//2Ofo6XeLUqB8bn+G3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7E6241790;
	Mon,  7 Sep 2026 16:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491661F00A3A;
	Mon,  7 Sep 2026 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788797318;
	bh=eGMn5/9sC/zi2FVSWOrMUOQZ1VDAtU/WgF3coPeOhVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=caUN+MPf9YppXvY6U6VEpgeTZf1MApSyRTpTPy8E055kTD4sujUzlB67rvbVzJWRV
	 LtfR7wK/dXx1p/1PP7LH9P4gEfGMpYGuv6o5U/EpvN/Da0CtFXjYJEeryZT1a/GcSB
	 oksP2ET4KnoZmbOh8Ssqm0x5FmbG67puut+4aMiFbRCyOk5dHj/Ho6FH3RSoXkbohd
	 HWaQ0D2SPhVcUc3eFBS6nITKnbURRqf6WrIgt3OsQvLkkuzr0Lbj3OXeEmILOHR3U1
	 uYZBp6Sm4DJysLDCQkSLWNsT12Iq53AwtmKibTHZ+r4HlPeG+JKKD5jMZSL5F5ClMe
	 dvSbEsa0bYaVw==
Message-ID: <dc52dd1d-f62d-4278-ab4d-95746383fd50@kernel.org>
Date: Mon, 7 Sep 2026 18:08:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Cedric Le Goater <clg@redhat.com>,
 Saravanan D <saravanand@crusoe.ai>, stable@vger.kernel.org
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
 <DL08J4JGJ4UK.2G92WO0NK8XU3@nvidia.com> <apEzvfGgsvbc3vBI@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <apEzvfGgsvbc3vBI@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 906194000B
X-Stat-Signature: at1tbwdogmynoqgtc6w85jcsouy491kd
X-Rspam-User: 
X-HE-Tag: 1788797319-850779
X-HE-Meta: U2FsdGVkX19TjdYaJu5p0Fs6TVLohkiWobuZggWIZhecV6wJ+eNaJlBYKKMFAu8Od9usfFlvXjOKnD0APH2wwjQlBGyi6OSDCa3b44E4afYij2ynTF45KHkcX808IM70TDj8QOKX8ryfxLgoBqcXcE+iQ4sq0QKDZeQaifsL6Gw9y1zKF7G/xdipyDdh7QnQuqhNIEBnEnxZuO87fkPaFDSsFYqMH8HkYE8oQGDS7DxCjdCKflRFQPxTG2dkrDh/etr454q3ctX7q8PJFEPswP/XlqiFyi4+Oxc4mY328N8y5wDR0NwIJNt10FvorGVlfVHOAIpm08YrIR6JWZzvTcEOJYGT08QF3lFwTm7cokSg2tdRnz8fuO2659/iiopeMZgmTqWVnMrLBjNbaiaaLBb9Dylww8uIIgLqWBkG4n1Xdm3B9YAw4c0tZNjzYE+75K16X7JDMQcFjFMJWHofdfEQYrPBBjIU2tU2qsSAcct+tT9Gw/SPMQP/UAUg94fpO/QKUOd/9n7befjyTV4YxhJgvgkXmNta+2vVcrQ9gNyPGHwyLFuxwfPgBiiCRQig5Kn/pf67ZA7Cavbar0+t0CJ3RbVsVUWszZwW8XeZfJy+Bo1AuTIYRspX39nm3cPMg90mP0FgnrWAX1kcCDofsV9hU3pJGr+KYaCgHYvLgK5/3G6u4qKDN4tNuYXspZbRv9wikvcplk02Df0TN1eMP0bFK7uhe+ikJ6ApihLSSaZxmoBViIWVFu76QhwXOmVnhNCmFSP/ImxUcWNSGMCswtcn5zo6PrwBNM9wIakQdR/V/HbDP57vOTX9yE2a4JjHpf7LzJs5Ji+/TYxf2AKi/tKgn+MRWs4M/kf4NPFWbcDVPntQ4i/BEXQ01pg6gF3e+amRc4oPGbBgI/z0KQOBrtOdm6BqiHQfAT5oS4AbLK9+jboQktrcVudifSULWjrD8Nrel/VmtqDg6cCtnzU
 ERZgan7H
 idBOf2QQHPP8VUVY+K8nzbJqWfEtu/nvokrrwtSdVjHj5PIksnTYaELmPIkyQkVkCL+RxGD7v9M6pPtXcbflkTcaaEU61KqTPqduKS/wZI2Qlc9gb8f8zZfW3+8HEbKsrtoQy89UBVLFzFyfZ0hWnoES7k/8CD+t9Nb9DxsCKGuGph1XRoECoLfnjRGdUOvmCR9v/ZOhpIG9XbNDqEa6y9zm8squvQ9c/y3bSZurT8PEMO6hHCtvBDyOxoqOhmDp06tO9lQ66EEypwiODQfrugW/6OuryTzTHaQ1h03ZT8qG44G776NzHoNbKMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> 1. is vma_allow_thp_tuneables_file() better? Then all three helpers are
>> vma + a verb + thp_tuneables_file().
> 
> That's a good idea! Much better thanks.
> 
>>
>> 2. is vma_file_ a better prefix than putting file at the end?
> 
> Yeah, it's an annoying one as kinda want to say 'file-backed VMA' but I think
> you're right vma_xxx_file() -> vma_file_xxx() is better.
> 
> Andrew - could you fix that up in place?
> 
> Obviously if there's further feedback I can respin as well.

Just as a general note I really hate these in-place updates.

For a reviewer perspective (like me stumbling over this) this is just a mess.

Resending with b4 is as easy as it gets.

-- 
Cheers,

David

