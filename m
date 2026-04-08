Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC85EFD5F93
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF966B0088; Wed,  8 Apr 2026 03:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90476B0089; Wed,  8 Apr 2026 03:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F366B008A; Wed,  8 Apr 2026 03:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5C7F6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:47:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D1E2BB7E0
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:47:18 +0000 (UTC)
X-FDA: 84634608156.04.936636F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F9F480010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:47:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcNdlwoZ;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775634436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpsn2tfYGKcQ4OlEN/My0p8h756cF4UDa7Kk//NdJT4=;
	b=Ut/pHzuqaB30Gfu6uGODMPbGTVrpb4WJc7Ppk36aM03G2IvMroNrPjqDnkhUBN/sbl7PhF
	ykTxwlEq0JnH/Orsqw3VUK82DGv9uvdFiVTiUc4qRmKYcBYLiJeWU9aao8xOQWdI99Mc7k
	jF1H3aOYP1w44BTCEGCRX7Ys2kXQdfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775634436; a=rsa-sha256;
	cv=none;
	b=lpexBAnmsxwPX6qXjp32x4ikew1xnLdUHJNzW+FkPAAtxNmKlcr16Lx/ldrPLh0axym0i+
	j6QPelJyGVl+7FDr9eEjNSNV0ATuH6na6Em2bZ0BRqXzq3MvLu0yIvxQgwqP+pLK+najsi
	XIBjGL7xu2p015Seq1osZ1dVl7ARWMw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcNdlwoZ;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36D1540A33;
	Wed,  8 Apr 2026 07:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1645BC19424;
	Wed,  8 Apr 2026 07:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775634435;
	bh=jdEruYUl+aeEf4DiKsSqlHsdtJWhcjZz6DBIPAY3UB0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dcNdlwoZm/G9O2+i7+xZXrk7wT6T8L2tR7bMMvkizRfDC72eGACYH9kgM67oaMm8B
	 5i6ovqZ+IRzm7shTVTKqkRfd285vk2jWJ8kLs5y3waj/vAzaRm0Aaoa6+2UnGpxaTr
	 20hKKIn5smmGaJ5sdb0qXBKhLtqysYZPoHw2A3s4sEUxZC9Fd5l+EY6+ose6rMMYm9
	 9AUI9qXQcDw97VETx/pY+3g5bhdXCPCoAyuSvmvpT1QMu2Q0IaayUuuYFhLKUG9tWy
	 37MVcHJVbWwv1XGL75nN5ogqMcDrHTM3eU8plltJA/xssCuU1t58+qAsM3BR6PMG5i
	 QnSywdi0j2GaA==
Message-ID: <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org>
Date: Wed, 8 Apr 2026 09:47:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via
 debugfs
To: Juan Yescas <jyescas@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>,
 android-mm <android-mm@google.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 lsf-pc@lists.linux-foundation.org
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org>
 <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org>
 <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F9F480010
X-Stat-Signature: qys71ss6in7q5rtc9ew5o9goyw4td3nb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775634436-931817
X-HE-Meta: U2FsdGVkX19Grx35pbI1fvG1d2pNfHmqBBFQHoARt7satFBtuZHdo3KlYnjCkVOsvmbE9WaMTNEHOa7mvlqAym5M+eWDPPOAFwIMPHELt2EuafUu0Z+bEy/9sasUd/6chgdO3M94yhYg9TGtR73pIOzocjTxKbsQLxDf1RJJOCoWzLs2fDmaprdy6hHg2b+dsh6NCX5AtTziOkDmNUvDIaZ/0e8ikUpCF+Cg01++bPuRqj16OgY8XkoVpsf/hvLwSUon0YBv8vYYNKuyg8i8r/RlnDFMjzs8GO82rxkhwOaGJhO3dE/rH+IBIxsIvqCdGcdtEnga9ySSFUBg6CB9XZnhsDAo8tf9rAIKodeeQvCeASv8zFYbsZQzeN037XOZhs3JJvN4/Cw1f5eKSG++m+jHydPCskYat/LMS70qXq75EJJI5Zw4rw0Q0V2+81AcjXRVHo1UusNbY2PolUcRBpQWMVbbdgeD+Dbgn1zQ5r380jITBD/UivPv+B/FQoSuC78Rta7NGZmer6GARVcXeGBQzR//2u8k+xWx98MqjU0GT0vTeUyE0+chEdBSx1CaeBgEPgyFQSrKBNrPXSU7qccqaVLciASYyk9nrZ6XmUPlTsZTlvy7fhfAvsitBDBXcX+kTeohGgeR7/EGXUdAzeqhA/S45HkIbQoeiftSo2cjWT7uiEl6Zs6EXF5fhyMaZtdbTvonap1Z2M0g2CW5Qve8+CGI4XEKw41BRBjXUkCyFc2e4WsGDcW2sdu5mJOtwO8vCZDaYtgmUw3eR5xqm1nqbT3EemC3iErbIBw0LS1PuhkQK4wZ/v1U8SXTs6mcV+1DCbzlNHLTVaDCzMhlUDm6y7b0uNNoUdv6Hk01aTwWyZgg7kIVYLNPjIBNd+ASkAdLaUIydJ6aSAYvBnifB17nnPuRT7J/4zBUItw6bBjwGMg1MW1AKHZySi8U4ld/2x0G7VQywo7JG9DJHv+
 /fOOYoKC
 iry7uS+Dm28rcfeGDe1ArJIcjbv+E4X1miDgX6YdbFoUM+90dnvlsc73j05eeWrEH2peV9C+vUuxwN8Mx7EugnGYZwqufLuqRuwRoivU3r6Dx+mwl3TlQWniNkYJMMe/h8eXZQ8p1K+rU84awPM/QaOdoet3QZNvbFHQtTDce6DZJsNzNcMcw4q0Mw79ribaXv8MuJyKmaIkcmc2j9ZOZIQsAF4Y+D6MbxYrRbhp0JsRUx2E4ARKsatHPcMTnTSTd9anyeeek7vHX259+uOykOFY2tY6fXDUhDefwuhnk1HgJdjThK0DYDGVMJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 02:12, Juan Yescas wrote:
> On Mon, Mar 23, 2026 at 2:14 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 3/19/26 01:56, Juan Yescas wrote:
>>> Thanks David for you comments,
>>>
>>>
>>> On Mon, Mar 16, 2026 at 8:52 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>> You’re right that going OOT would bypass the strict API stability and
>>> extensibility requirements that come with being in-tree.
>>>
>>> However, there are some symbols that we would need to be exported in
>>> order for the module to compile.
>>
>> Reason I am asking is because we had similar discussions around memory
>> hot(un)plug in the past, where we decided that an OOT kernel module to
>> simulate add/remove was a better choice than exposing weird APIs to user
>> space.
>>
> 
> Hi David, I apologize for the late reply. It’s been a bit of a
> whirlwind over here with some internal issues.
> 
>> Which symbols would you need?
> 
> These are the required symbols:
> 
> ERROR: modpost: "cma_alloc" [page_alloc_debugfs.ko] undefined!

cma_alloc() will be exported soon:

https://lore.kernel.org/r/20260331-dma-buf-heaps-as-modules-v4-5-e18fda504419@kernel.org


> ERROR: modpost: "migratetype_names" [page_alloc_debugfs.ko] undefined!

I'd assume that you can work around that?

> 
>  > I guess we'd want to call the buddy by
>> specifying node+zone+order.
>>
> That's correct, for the no cma allocations we'll call "alloc_pages_node_noprof"
> 
>> Is specifying the migratetype really relevant?
>>
> 
> Yes, we want to be able to allocate these types of memory:
> 
> MIGRATE_MOVABLE,
> MIGRATE_RECLAIMABLE,
> MIGRATE_CMA,
> 
> When the request is for MIGRATE_CMA, the "default_cma_region" will be
> used for that allocation.
> 
>>>
>>>
>>> Yes, that is actually one of our goals. We often encounter
>>> "heisenbugs" that only manifest
>>> under specific workloads and we want the ability to stress the memory subystem.
>>>
>>> For example, if we want to increase the unmovable allocations by 16 MiB,
>>> a 4 KiB kernel, we can do
>>>
>>> $ for i in {1..4} \
>>> do  \
>>>   echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Unmovable/alloc
>>
>> How will we handle unmovable allocations ending up on movable memory
>> (e.g., ZONE_MOVABLE)? (e.g., allocating from ZONE_MOVABLE)
>>
> 
> Once the allocation is requested using
> 
> echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Umovable/alloc
> 
> We don't care whether the allocation comes from movable/cma memory.

Well, you should.

If you end up doing something like

echo 1 >
/sys/kernel/debug/mm/node-1/zone-movable/order-10/migrate-Movable/alloc

You are just breaking ZONE_MOVABLE guarantees. Or what am I missing?

> 
>> Also, is there any reason why we can't do it similar to hugetlb and use
>> a simple "nr_pages" variable, that can be set and read.
>>
> 
> We could use a "nr_pages" variable, but we would also need to set the
> node, zone and migrate type.
> 
> It would be cumbersome and error prone to have something like this:
> 
> echo "Node1/zone-Normal/MIGRATE_RECLAIMABLE/8" > /proc/kernel/debug/mm/nr_pages

I meant something like:

echo 1 >
/sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Umovable/nr_pages

(not sure if we really want to specify the migratetype)

-- 
Cheers,

David

