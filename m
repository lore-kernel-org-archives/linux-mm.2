Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D172103E179
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 13:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9C46B0201; Wed, 18 Mar 2026 09:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A706B0202; Wed, 18 Mar 2026 09:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289796B0203; Wed, 18 Mar 2026 09:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A70F6B0201
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:38:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF5618C304
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:38:26 +0000 (UTC)
X-FDA: 84559288212.28.7CA2F22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7D96A0017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:38:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpdTpBQJ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773841105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bt3n6RYko7239te5eGqF7xtKOsk2YhqT4LodlZkwXkY=;
	b=aIOPnp5Xi8foRUjGOxcBe0J60GfC4j7juVPn0RMiTVWymTxKaxwf5Gn7MpRK2dHcDMAkTI
	+09dEdvScjS1AMq0RumwddtQztHiPOnwQrB7fjLTylcQX+xGXgGGRGs0NgvTj1PjzVK31O
	31B7QZ9fAzBc3mpn7G8ymp2kmexM5ZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773841105; a=rsa-sha256;
	cv=none;
	b=Z+gHEdxEvbX27ZpfaoHQ4M1lHrO9pU7+Uxd9x313f2DroX+z59z9uzWZfjl7XGcJfefQsC
	xpfvJjC0wopGdSKhL78jijRLl0YI2hGa+MrXHZSEtFnkvYue+7xGBX5MQE4QDh/OtZhlvI
	TBY1YaCNSPdbJ5YxtAMGemH9KV9uQWs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpdTpBQJ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F71F40BCB;
	Wed, 18 Mar 2026 13:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5884FC19424;
	Wed, 18 Mar 2026 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773841103;
	bh=2WYHgYJu4lxc+OEYkcpFBXY7V8c1zaEJ5SVeg05phfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mpdTpBQJ/O4UdjI8BQaE+u4Zwyof+v25oi8qWSOWlFxHUB5qK0VKNEnqSluVpg0Lx
	 q5WLveW4jcIYoomhfAdJklwZTpJD03PzrYsmgsz8e9obqq5d9riKJdMPoe/4Y0cchr
	 D74hKcYV6NGQUwl/R+krAoICgJZe04MOpOivtWBzbV2lPQq5bp48/PiYuKV9MQ2Pi7
	 40m9dwDYskBM5yOwkHHutKTFI8zcK4lThq4d1Eyz8RBMI57G9LgiuEwURd+xCbqGNR
	 h6WRIT8CT1/Y7ha/hskCihnUgfcDLJK0RWEov4muo7vFFqzabF6QTW0GkUiDjnhr0o
	 oZdysGFH2N+3w==
Message-ID: <a90233e7-8dd0-4c77-b048-d84b869a6a4f@kernel.org>
Date: Wed, 18 Mar 2026 14:38:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel
 <riel@surriel.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
 Jann Horn <jannh@google.com>, Sasha Levin <sashal@kernel.org>,
 Jiakai Xu <jiakaipeanut@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260318122632.63404-1-ljs@kernel.org>
 <e71acbdc-f46e-4dac-a88d-5b297f518dd3@kernel.org>
 <d1ae6b20-ffe0-43f5-aa8a-9f6056b5ec51@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d1ae6b20-ffe0-43f5-aa8a-9f6056b5ec51@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7D96A0017
X-Stat-Signature: giz8u1ebb6wyhtobk6jraywufgrzd9rg
X-HE-Tag: 1773841104-529638
X-HE-Meta: U2FsdGVkX18Oyn5Ff/uX5ayc3xvm366mTCYN0o+BX7k6k2JEazj/QsnESdGP3M9efmEFnuxur563BFBnVlTVpYgs/TcHeSSYIcKlE9BmycffhPuIx6O7ozR+WM84vDPxxpTgdEVpbhM9XG/XPHxATsP6GS1u6h5ooH2aE9SvraekmuRRDLcJIxz0YnVKW/QZuyhJc8kaBjuzNOUjQZaf+pgtPyd3xwaS25I0zdbKyvULsJvA8u4MXEDKoJduIHR1O+q2LJunLZZ8vSYgoK4fYC9+E03Elvy4wIS/ClZmOq2BaVr0lvyG+OLZMKk9ZpfPWRoOx9cfbQk+ltP4ktkqbhLWUrGs2EcdRwyrUVGHIpOaYIoR1NXQtgzr/gVqFkco2y7X5Lj2GLQAOZ954fCUjnxFN5/ppKc3bkvCmg15LmcO2wiMPGDpqwZ/R4K9Vk+tuQ3UUhRw7dG4/26+gCEgpgtyRi3/Rw0Y8a5J8gxVD7je8AEme6warU5pH8FwpMqtrb9825T43oxcqPFY3PcaolxtpgO9ZRy6C6Dv4eBF3Km1Aa7C0eiM1zE4+MMkw1RSOCQMdfkh5cXxeEibgzNsqOAGMq6G/r5UJTZ3hMHuaWurrf3Y12oFTP6+/HPodv8jZRIbUk+EKf2O3m5AtsPSItwtOfcJrrW6kPnyWfX9LmcZhSvadi2uOU9fikoSQd6dTHMSSOwQvnrglxU78k79QqELLxlZezTazARjsETI3YFNr2VXTHklqpvanO/AavfdFxWbX5fvo8zaxaOKdBZOdj7PhSaUvbWfnw1QT5c/TxPGC4vQ+o9ZMP+h7JqSu7HKRUx7tDZmDXZqNs7PLoLEAFcDInc1m0+fhgwsVCX3Yr3jGvBV8sKg7nIvFoaUcSQ82Neee5zWCrtMqZ0ERyjiaCV6wStzcUNwbLKKQzuK5V+pjyoRQyhmjYfQG0nO6bvfnmAlaYgoUh21Un0nTF5
 QvkJFXFL
 JiQ+Omd9dBf/2ryrxCRAQK8CFx5xweCzImaFFEJAaxOSqRHuF/TfcrIESFNV1IMrzAdIxG/0MlKrr2bVS5eaewEg932sMKU9aPPuEYAFrHqodeE4Cz3lDzPB3QC0S+C71cLReQpMXABEqtJVykmlmNtF+epVNU0+NQipsfARwEkpCAv/+V9zOA+k9BLqz4DzwgJit4X/5ZsPb2CXCwIbr2HerT0wdXQ2orF4UImfAJXmJKzm6eHMHmfUz9oC4/2o3PUra4tWSwl/lPiE8PljIZBSVGFQ8SMCXPJakuFZWWCG/hAreBxjXz0DhAulhvfQ5mQBBRCedBm34xh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 14:03, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 18, 2026 at 01:52:44PM +0100, David Hildenbrand (Arm) wrote:
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
> 
> Thanks!
> 
>> LGTM. I was wondering whether anon_vma_clone() should take care of
>> setting up dst->anon_vma. It looks a bit odd in dup_anon_vma.
> 
> Well in the fork case we don't want to set vma->anon_vma, as we use
> vma->anon_vma to denote whether or not we reused another anon_vma. For
> split + remap, we already duplicated it via vm_area_dup() ->
> vm_area_init_from().
> 
> But... now we have enum vma_operation threaded through here, we can just do
> that there like:
> 
> 	/* dst is unfaulted, so inherit src's anon_vma. */
> 	if (operation == VMA_OP_MERGE_UNFAULTED)
> 		dst->anon_vma = src->anon_vma;
> 

Exactly what I had in mind.

-- 
Cheers,

David

