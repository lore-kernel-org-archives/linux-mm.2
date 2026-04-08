Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70AF4FD5F94
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924B36B0088; Wed,  8 Apr 2026 04:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC546B0089; Wed,  8 Apr 2026 04:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812296B008A; Wed,  8 Apr 2026 04:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 729586B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:00:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 034401A0A94
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:00:51 +0000 (UTC)
X-FDA: 84634642344.14.22209AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 148F840010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:00:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hX0fQ62q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775635250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+4NxkzltJ34jKYD8jix0BnL3HVw3KYW9V13J29bcdk=;
	b=YV1HsqrUxQNf4FxTs4eKkAJAsLNuzRN/cuy/MYc/EahlJspydYddo30Wfu+NJE/nZ5JkyP
	sC0RYfs1pF+FO5ibLlJfSr8hmp9MOKseEtRn1zxxoJ61AhYIBsAAAUvow31/rEU84c53rZ
	j+q3dQiGJTzyveHZsfMzd2nzI6bQ1ms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775635250; a=rsa-sha256;
	cv=none;
	b=AFPFXV9MQW9ZRdIBoNXlobmBKATq1a8hu0RgMLGt3tPqQapJDcoxgGvLOMIe9OP30H5VvC
	QlhuW0tVtieInKc3PjuqwmFL/jc2Wnd1fHS/vWzgzd4Oak7CxCHWk2GQalBrwKycYRuZJ7
	rEMjxcpOAqRq4lNRMtSGw0LQ1dlHhQM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hX0fQ62q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5CE640266;
	Wed,  8 Apr 2026 08:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D8DC19424;
	Wed,  8 Apr 2026 08:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775635248;
	bh=UT8tFKt53agYTgvPJj5mpAHwn7gFgeu4GMF5RURLdmQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hX0fQ62qnipeIAyjyPZ9g+Xox9WG/sYpVUHwTnjU3O0oTFOhOjgPSLcdaDwYSGC91
	 /nE4clmD70fGds0pYjuSqS/wE20qKjNbuEpsBQpUziLxIHoyU48yOEa3yg7LFFvgDo
	 +A7dPc2b97myZvkkMQFe4f0jqFxVXBN1w/bLEYc5as9fUT5drLsSwVYmd6gftJYr8W
	 uWfHmwJux1rBcobraMrvRdLNRjA9N6p04eifWaYK0ZW43zlUIQFNd+ZZqdOxZMdnlN
	 zFRTHKGYJMT1XOVdf9aCjCLQwwlioqRKc4ltc0xd1n0eUKl/bM+zCI20udW9HZAoNy
	 GGsi+4JeWUeYQ==
Message-ID: <c6b9712f-2f23-43e4-b270-dd3a7371e57d@kernel.org>
Date: Wed, 8 Apr 2026 10:00:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15.y 0/6] mm/hugetlb: fixes for PMD table sharing (incl.
 using mmu_gather)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
 linux-mm@kvack.org, Jane Chu <jane.chu@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Oscar Salvador <osalvador@suse.de>,
 Jann Horn <jannh@google.com>, Liu Shixin <liushixin2@huawei.com>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 Laurence Oberman <loberman@redhat.com>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
 <c6f63b74-d532-4384-a1e6-2b0dcb7b5303@lucifer.local>
 <2026031222-vacation-cramp-6fdb@gregkh>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2026031222-vacation-cramp-6fdb@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: b1z1b1d97i5kjofidjjbxeyfsu8sjan7
X-Rspamd-Queue-Id: 148F840010
X-Rspam-User: 
X-HE-Tag: 1775635249-960785
X-HE-Meta: U2FsdGVkX1/EaOzf9ejRa1Cqxgt5PE3IGuCQgA0DfSMYM1JLQwSzjO4kle2572UeXl/CdK3fNYZedIEsAFPln+DfA79DMwSsrLXlUAezuks+QHZwjrOOchiYTt+By3TuDVlhzXz4C0y78Fiyw/YCsK2Borv8SMgKHEKVMdM7glFk4HLq9J1rD9SFiqy6WOYNettVVrEqOsMk02TdYlQz8Sw7IE0DifJnwooJBJZIbIOHCAeJkgJqmFNRybjDBE/yTRpiDUmMIs89URacfxxOs7TbqhGkUJN0DVplkGpCfkOaDAOK9MPyekLAAcT3LRnXpwsz+NRqtxmHMj5ODL7A4bZe/rT5ecnmXrTf252HjAHJr8piWiZBryBZ2pydgVuWPtG+1XBb7Lb0DBK55yqSTZMdx4qMLkUtn9KA08lfzItuq2ULekkLhdHIhkn8EXhNcrJiiMIA2KHe70kjN5ySMNF4Q2j6nRH1SOa5LYZ4gr2cB43Wd0TQXOvjfBMgV8GWEirfnpsNzNNo+U5gxhOaCrWLeR53zES2YDHrBZKfHy2316el3NBRgka/uF99ZPJ9f/cR9CV/V3x1QPSqP82yuL0Jlkfa0+ihBIWgvkqImjLj99Ye2a2PmwtKEkoAi6V0zeie1eOlHH1xC/w4HUSAwCYrITnUox3B6v6nog25to+qXMk4AlCapy7i6OBeoPz3WIgZVZazhqbKNXilG7R4EgF5DgY4F1uWx+VOm2HM4jzHAVad3/qOg78fcqhU5ZfX9AkslCyuBEp7dSSYHzrHvHn10eXkTCrdVOmMDjXkIWkGqgt/pFSdYowEy2SEjKarqrj4q/ZWCffp7gRziKV7mAYfTP68hmI8viZeb8g74WAoqUxyFKxUirLNqb3kePC/+fGLirtAtxmQ26VMQhQZF+KbchpKtzt/GykbOxzQJzbdaXbBeyqqX/TbkfZzg6bAlvyXCZ6iW4iXq7Cvc3I
 M1cUsfW0
 G+OlaR6/h6GNCmo9/abOyoGfV8uWCTv8RtlpLDdl9ZuinpKGrV33d83MUMxPmge8a4GEVpPq5cKQ/hvU2j3CfWzqwZqV5Lr9RY1JFU4MYOGc3/8wKaAz7opcpJLH3ofQoouFdKkNPKcpfjKeiS+alzUKKs6rL6q7+IFudemd3HpuUoxr19jjVXUcSy0hefqFyrTro4c5EVevICJ6y28Er2WvBc0hDru1qbMXYlwCOqDANQ13XDDK//aotS6NJYmN3LJMrWtZ7PsJ8rue0TzbSZx5n/96wQdbVM5mki1bg/C5tlZRGUaZhPQWGYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 18:47, Greg Kroah-Hartman wrote:
> On Thu, Mar 12, 2026 at 05:42:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
>> Hi,
>>
>> This series was sent a ~month ago, is anything holding this up? The underlying
>> issue is causing a really serious regression so it's quite urgent to get this
>> pulled ASAP :)
> 
> I see 70+ pending 5.15 patches that people have backported that need to
> be queued up as well as the pending upstream patches.  During the -rc1
> cycle the stable trees get flooded, so the older kernels take a while to
> get released as they are on the bottom of our priority list.
> 
> We'll get to them "soon", they aren't lost.

I assume that is still the case, another 3 weeks later? :)

-- 
Cheers,

David

