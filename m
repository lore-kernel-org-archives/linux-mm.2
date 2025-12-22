Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A5FE674A9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75BA06B0005; Mon, 22 Dec 2025 09:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C6F6B0089; Mon, 22 Dec 2025 09:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C716B008A; Mon, 22 Dec 2025 09:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E67F6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:18:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C27F13313A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:18:39 +0000 (UTC)
X-FDA: 84247312758.18.F18F81A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 15CA140011
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:18:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWgvlFeE;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766413117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GWAg5mCU+2KdCTOJoIFT+XZqxuNuMwUtL1s99pDJdE=;
	b=aQkZqpyjuzIthXd+HOkcknSmCXOWtI/jdTacg4qDUBE0HjsZq+I/IdukRelYH8ORVYs9zi
	k0PZyeaq2Gu7pYDSwaQ8CcWXBkQARvaMJzAEmoJ1vQvYGPZX+NURfzmOs/H69Co2BH06dT
	2foBFfqEgEDe+QQI9s/wx8wbzhklbMQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWgvlFeE;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766413117; a=rsa-sha256;
	cv=none;
	b=YqXB+uEKeGgBeqcTI8zormvMIPTMkrOUQDIs876oBiBg3pgo9DiRafEP8jFJpB3ZY4zEj3
	ABDLogGiyXiY77/qPphLjfR4ID54WOpTR+L5kadRqUvRyIWOf/WhdSktiNyzAGrNcw/sHo
	6ItBTNNzOfNn6bNfb35D0Zi5854rniw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E80DA43A9A;
	Mon, 22 Dec 2025 14:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C533C4CEF1;
	Mon, 22 Dec 2025 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766413115;
	bh=5oLoO9OoLlqXGFG0p2UfKM+IYdkIP8vX17iyc6xkjvA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UWgvlFeEPgbZsomKQU1NvUIqK9fYWIkSSFCZHKAujA8KMLt8SSs6oMNOc2uIQPKib
	 uEH7FKwnZcYGq+Z5VDNECI06wwfFScwuZ592Ebe8nEoIQj6ruwaOfLiLGKHqYIB0oH
	 d1uIgkKv4jK7+8++MofJdtFvbV/xlunr1UjAD3MYlrLntzIOA8Tz8LX51EvL0ev4HL
	 XhajvbQRN3wQZIB1kbvnDqPFHHuBbnVT+ke69lMC5yQ5fCErx4M7nL5q2JBvDQWLsx
	 KStuO1h5ulmIRoiwJBTkn+5YcEgRwrz5jfBBK2bo8sxTsDo3ZTZO8sBmue58hiCzeT
	 OBPdUMlA59PQA==
Message-ID: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
Date: Mon, 22 Dec 2025 15:18:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
To: Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-3-kas@kernel.org>
 <430d554c-840f-4813-b715-5191d74571a0@linux.dev>
 <4ctnfkw5zqneume6px2wqgdgusfdricr4uuonv7bfjheknrt2g@fdb5ceiiar4q>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4ctnfkw5zqneume6px2wqgdgusfdricr4uuonv7bfjheknrt2g@fdb5ceiiar4q>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pqg73sb55j5uzzu5sxzhi4fhpq4q6ieu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 15CA140011
X-HE-Tag: 1766413116-296490
X-HE-Meta: U2FsdGVkX1/l2d52cINR5+US1qX8P5ldzXPZVeNLjYKJZucNSHf9Y460jxve1wRJROE0kExnbitSlyUoqaCE81HhNjNUyLlWlGC4ZdF2xPX+8KjyDnAur5iyQt/3xWrp8OTIppKaun4EzpZ7ctxgJgN52YUDkIOuyEVyX7pOFpk50NnYlqjCby17B2Vj/9THrxBVlVvMEJzIrOcqljxw1X6Q6S4v5bxhQIF3sZh2EaAA43+hjf9YmS6Lo1otRGSevOEiHMt1z8VDCN2R6u20Q6jcZReOAzY/sLRnu+2XIONfsvWYzafXtidiyqYkcuvKNWg0ukxmUPBtv8b08hEduLhl2VtjPvLJu+bdKF+tdm2BTjFde2ITaPmvhIg90nfIAk2zvPSW3rjYDAHth4fmU1J3SzHu6TwGh5aE5WNqP3AJOuPtaTGHH9uXRHrGwCw1VNEWhlEP4LQ4az/+9KME5jrGh54vGfWFNFexsF/TBd10SbuF/Gbjgwt/qV0nCzTUwcjkAQFIEEZ5QC1UvsZhKJoxWXLvZ5F95rM9wW8nozE74zrTms0CmhaBCy0hCgSJGo1Nl6703FEuHy9aQA+iriIe2x/rWSWCl3PjALZTvUFEpS62nra35ZeKct7S73ctiCG24L+HHXfIMzV/jYQwqZgFvUMa7/9k5A/VU/HJpraubXRxGxaqcRSwm6/Vf+erGDa7aPuiQYhExQnCbJmatT9VbCzaiHdU9itvG4mrjP/z5E70oTKS5kqA2VDJGTCCpdAnkqfy6/ofaPBZ9SbeDAMQ5oyPYAnxDka9VQMr4HPOMX8IiExnhLJThG+ECsYkyjz2qDge6Mghub3/52XXjA87+50ysBMq08Hb1y7N3l2nRH/GKgD8bu9hUFB/fe6UsxBH8IZE/fKcWY7oX4ijAyMMBsZ+/dTBc53P6GRFjyQ7Ka4K8/OTWWgYTS9i1vHQ5WyaodZ53Jk5i10stC3
 2JCEgcF1
 y5c6DrqPFKa9oLr1dGBv76IGb32Xc63QqK/lCV0HEMYl2GK5oZOf3t8g7pgp0c/95nI6iivZt/1V5FC3IaLCqXtOih+rk7y0Az/loL6Sr1d3C6zEyBLSgw54sxuLIuYWeopCzcL98B0G9w/lFwAPUR5vrHbR1RQIlG3w8GsyuQIWIi0GS/VcI5G9jKjkc0B82G+pYuK+0+GIBRLybJXAvz1mbK5OXSfOK2OGsPdgNrpywndckckgKdYkPfHMT6r6nwUNGRHbxk2sQLay5BHxo+PWlJDiIr0rdTBYW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 15:02, Kiryl Shutsemau wrote:
> On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
>>
>>
>> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
>>> The upcoming changes in compound_head() require memmap to be naturally
>>> aligned to the maximum folio size.
>>>
>>> Add a warning if it is not.
>>>
>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
>>> kernel is still likely to be functional if this strict check fails.
>>
>> Different architectures default to 2 MB alignment (mainly to
>> enable huge mappings), which only accommodates folios up to
>> 128 MB. Yet 1 GB huge pages are still fairly common, so
>> validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
>> miss the most frequent case.
> 
> I don't follow. 16 GB check is more strict that anything smaller.
> How can it miss the most frequent case?
> 
>> I’m concerned that this might plant a hidden time bomb: it
>> could detonate at any moment in later code, silently triggering
>> memory corruption or similar failures. Therefore, I don’t
>> think a WARNING is a good choice.
> 
> We can upgrade it BUG_ON(), but I want to understand your logic here
> first.

Definitely no BUG_ON(). I would assume this is something we would find 
early during testing, so even a VM_WARN_ON_ONCE() should be good enough?

This smells like a possible problem, though, as soon as some 
architecture wants to increase the folio size. What would be the 
expected step to ensure the alignment is done properly?

But OTOH, as I raised Willy's work will make all of that here obsolete 
either way, so maybe not worth worrying about that case too much,

-- 
Cheers

David

