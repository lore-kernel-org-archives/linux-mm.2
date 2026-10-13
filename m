Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF42CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4206B0096; Tue, 13 Oct 2026 07:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084F96B0098; Tue, 13 Oct 2026 07:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD3E6B0099; Tue, 13 Oct 2026 07:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEA736B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:46:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51D1FA8A09
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:28 +0000 (UTC)
X-FDA: 85317425256.21.0FC5A90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 804F2C0002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bblOWDAB;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791891986;
	b=tgzGwqXo857Q3ocXj3VaL6hirrSJyw5evXbzU6KqLJnLcGCGeikZyd8Uwp0mMjMe+rsbWm
	GGIgzfO1pDkAqlNVF/ppUbj1MvRglSKp3m2Sgo9ESTex68+HVa1RsGwGrggfHz1iseo9xO
	8g1nQlcY83tATTvQJ3uiX+cn4E0xedg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bblOWDAB;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791891986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/tmAYlOAhFHx+eNdgdyJnJ6w70pbf6q57G4Ef/v6WA=;
	b=2zgZ39ur0WnfN07uDbPpGlaRIcoKuoKeGEmTm+kOVwH9ymt0TYHDbm7TfRn0E3shaw8Exi
	cveupAX2RlTicm64nbzbcOhFhfl1uYrF9zo6bxnCg905T+Dbipk89S1w1Xrl3iyMi8HkAQ
	RKhVdR2+dZ4005M/6zXsSUV6dwFXKKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD8FB4182F;
	Tue, 13 Oct 2026 11:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C461F00893;
	Tue, 13 Oct 2026 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891985;
	bh=+/tmAYlOAhFHx+eNdgdyJnJ6w70pbf6q57G4Ef/v6WA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bblOWDABuEdwp25mU++GNGhbXiuxg916E62Wf4957pUKGgr0htSYNpzQL4T1TiXD8
	 EgPU9HYh3SqjXL4ufnO5gc0V8LoSIFgrUjsKs+sc1L2CRFf9krf8IwkylMALxh1lM4
	 LgXEfw/iAYgiZeE0SbEDScGW3OfPVGqimnJfRmjOn3vIA/iCR7VkU8xl7flpJk1iMn
	 wG9XHH5ClDDVQgvMVGMX8IEhfTiIzfaHE0QgVdqblW3kWbGDiRWA95IUny0ruRu9iD
	 WQ52H/Ol0kulQ8vO115SbdHHXBTd/rsb5+F9a9dJs8OfLxoMYnkpYr7e3Djtfn/1i2
	 FKHYquSqWAw5A==
Message-ID: <53c19885-bed1-48fa-b18e-953f7b1e5d87@kernel.org>
Date: Tue, 13 Oct 2026 13:46:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
To: Mike Rapoport <rppt@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, peterx@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
 <67c30e4c-3576-4ded-a71f-b49075ed42e3@kernel.org>
 <as4I7OKld_XJbdb3@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as4I7OKld_XJbdb3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i56899badt185tgfkfb4wonqg5ciny7z
X-Rspamd-Queue-Id: 804F2C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791891986-590325
X-HE-Meta: U2FsdGVkX1/yaLin6EpYsjthAW62OvJ2DkRQSSsU5/Sse+7s3jhzy20RsrDxWs+HEDN1yaGBufXCmsHr3aXtFGykJ2g55PgSR9ixrX+GOP6tkiEn4haJkDZg7+1dcCUzeiC4VQlhfy7jclfFXbw4MfuESzNDGhb17MxUyLQN8vQJA66vTu9Dpy8RBJjbPC7DHnS4PG+ErGsYIL9nm9AT25Hxk/q4O8uOrihvuTIsHYhKRtbf4+DOxXMKzwS2Tg8nlJeClQiBzGBYNKgCAn0TVWRPNj3Ir5oolYDkzNo2wxYf7Hfr2BNFb15fi6ZM7i6VlVkpR6Wp8U6t3OhzFqHSnxclRLt/+k0FcTVxeHqzez1tNMdC/Zt3SMvLN0KzGI2QyWgu7BusDqAXnkJboMMGhAUQn2NrqZ14mw72EG1QvUctJtRkrbumrNTV3k6AqQtO1cLJ4sIlwhkf4Cz0sFkNYkOJEU9EnI5QfECpU0kCNDT5FKS73B9MHcslYoYAM/8WKAovdMxQ8LkrZBar8xW32Jvdu8IFyOzFW8CW2Z3fHpW9AmkeItpIKS5gyMBRLKazfVsy8xwrG/FaoGbZv/dyvEyF+mttoSMNeXdUXWQtB5nLl/1omB3+gwQFqqqu3yPPRsISZoWyXFnRLcmN/b+tCMt8Ckvvw6fYVMWp5wzVSAxWz8kueCL7NrWLQ1okT22mFc9A0lWqFQc1WF2VzcyyVYasslGN2JYBkpSim4tUCpSD/kaaMUob0IqOlU4g+yeNV5RJzIWLaz7lgvtpsJFP1zcd5URV2s0szNB23XPooZYVhmZZnsCKg0tADIb/M26FDSXohvnTpx5f9rUeMOyMhFPtOGdLHxFt9MMmSsM5EOdakPkkpNDukhEfJcoWnRHebgAMyASe+PEKa/Spo2KJs7rNTwWucWKE0tSD/dpCSkkfBR5Dy1RuzBrunoMbwf9Y7iU9ohl4wfrZmAJFqLX
 ABFInOXC
 687DBLHirQRxGtj5jBmXPnAt+/9CkQ/Q7Mny4UVtRfcINu66LjGMppyZJZYUYY4y/SJEvienSzsSiCMPcMAjL1mpK54Rvz84ruE13rS42405hkxmVaLLJHurgvUiZ8INqv9RcSm4RQaMxOK62tHOhWMqRufPjI4xrQt4/xHiszBbpyhL7bsT7PCoj4BWTnVAL8nDVhSYeLFFT7nZlGXy6OLSDPxmvQhX0anGv2EyNZvkUZVWcrzpYtJM8LnBtYyUBIbJzNyFFr/bpaao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 12:33, Mike Rapoport wrote:
> On Tue, Oct 13, 2026 at 09:39:54AM +0200, David Hildenbrand (Arm) wrote:
>> On 10/11/26 18:35, Zenghui Yu wrote:
>>> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>>>
>>> uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
>>> chunks of chunk_size and moves them one by one.  On arm64 with 64K base
>>> pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
>>> the whole 32MB (UFFD_TEST_MEM_SIZE) test area:
>>>
>>>   step_count = nr_pages / (chunk_size / page_size) == 0
>>>
>>> Because chunk_size > page_size, the test then aligns both areas up to
>>> 512MB, which points far outside of the 32MB mappings, and decrements
>>> step_count, which underflows to ULONG_MAX.  The verification loop then
>>> runs away and the first dereference of area_src faults with a SIGSEGV.
>>>
>>> Skip the test when a single chunk cannot fit into the test area.
>>
>> That leaves 64k untested, though? Why not adjust the chunk size accordingly?
> 
> To test anything PMD on arm64 with 64k pages we need to adjust
> UFFD_TEST_MEM_SIZE to have at least 4 pages, i.e 2G :)
> 
> Maybe we want UFFD_TEST_MEM_SIZE to scale with the page size?

That was my thought. If you have 64k you better also have plenty of memory :)

-- 
Cheers,

David

