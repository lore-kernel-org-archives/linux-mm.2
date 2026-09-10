Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E3AC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE41B6B0095; Thu, 10 Sep 2026 03:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC6F6B0096; Thu, 10 Sep 2026 03:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD32E6B0098; Thu, 10 Sep 2026 03:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D54B6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:35:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6084A046F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:35:44 +0000 (UTC)
X-FDA: 85197043008.07.9DB4626
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03A54C0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:35:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArIWktUn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789025743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhU5FRjwx3bIRyO70+0m2ZMAFaFYcoutIHjPJPwpjb0=;
	b=7Oy9LE9CMXo4ImLH5zeT8jGpAJ1LHjl7eE9OjCgNXDwiIpV+J33tf+0gjY0drcKQtPOGQJ
	kdjuGnmEXnaQvNp5tzgS4Pf43/wBR8g70pnyI+ehuGb3N45EolVKhTtCa6AypUzf61Hsnl
	dIvuaYWGtozZW0DKazStxBYTOLZK2jI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArIWktUn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789025743;
	b=ZpjSiZ9bOk+5Jq+qtsdtmWTIs3QMjUW6lXOm3hR0WO1rZu8Hz5Y1A4xFnb8SFnOs+uU5qw
	IeLOPbzfta/EuW1ELkSQPl2terDz1xekQqSh9v7M3MNEu/tb6IqMwo3zFEJ7nEG6n36u9L
	CEnzjTtMD/5ISPb209fQkCzCoCr2ICg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DEF041531;
	Thu, 10 Sep 2026 07:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C231F000FF;
	Thu, 10 Sep 2026 07:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025741;
	bh=EhU5FRjwx3bIRyO70+0m2ZMAFaFYcoutIHjPJPwpjb0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ArIWktUnX4ZHRqyfQgODDI08WST8EkyZQTS8kC93Se4E6H+syeu0Dr629/uyOcxo2
	 9lgDK7KIdqL6gH8zdsEKDMnghdylnYh/hgGmgjgckV3SuyLN3390WGB6RPcog6iZXu
	 OO/XEJi6e4/AaARzYg+An6QISxOXdndN4CKx8wDo6NDo49Xtm+zM83zuqP9ojMdyrh
	 FJ/tn4Bjrr6I7LVgrjwJ+mjKKJsCdyQlGI2Yo0hTds7SKfO0E1tm9OrFvbQ/gVzmbP
	 h/8wPEBM75as9OPp4JVezB3s3pKMrQs7tyHW2vQVnUqHjb6/TvJQN6QSyeroQtw2rI
	 5jj8kC6v1vixQ==
Message-ID: <927c0ec3-4183-4355-9269-721d79f4983c@kernel.org>
Date: Thu, 10 Sep 2026 09:35:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: Tal Zussman <tz2294@columbia.edu>
Cc: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <178889163877.1334491.3646957026033534678.b4-reply@b4>
 <83a8743b-9cbb-42a5-9ff5-718297916a76@kernel.org>
 <3dfab5df-c205-4853-bf48-86351a02b4e2@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3dfab5df-c205-4853-bf48-86351a02b4e2@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 03A54C0007
X-Stat-Signature: ubpnxtn8iq1448rcjbz5u7y976e6airc
X-Rspam-User: 
X-HE-Tag: 1789025742-910491
X-HE-Meta: U2FsdGVkX18uo4DTC+4mR7+DnnyHMb3gaG3s4udLNtgB1Cw5PMqzyyXxhbmXRCw9d3i6cR2pZWN0O0jX+x35UvazzxMvQWArxvG02McqDSvRUjHXp1/k80rwVqZcziI4rCYTehlu3zknT1fOLrDOGsXue5dHSlP5V4TrRu8YyJfjNvNYadE4Fg8KtRU7MVtjxqNA/OdDMHy55Qw9WmVzk81HzrcjFddkLnqLXXVQVzjsVEcO79woU8HarCira+rmilrG+xMQZDNNxT8sf3euJ2jaSodVmzuXJEDIdbMkVuAZmxXIiHPu1Zphwg0vKd/oKgVq/tcybDhakp4R1W9LwIb2jROOjhQJydkO+YwkJSdxOQBARy2hPsy/qPzHiUqfLhGey2pjumd8SaKe2sNANyT/MNicRzdSi62JrCsJeJq5X0l6fan0C0WtjmXabWzrSbLEzCxe+eGUpbLZA0Sn/Gk4lDrSbhzq+nXC3uRK3Zw5yZpAcfjGxOsBFbl/Q0gXwrOl6DWBMCm+odMQ2h5LGq5cyGmfnPK8cGwWcRfR4ImKEv/fTHUviK1Fj738BNryKJHQW9rZrC8bATI1yLAWti5FHoxn8GWiyBgvXpI/PXv+q/2hCR4GPsoXv+kYjPtfGr427o824MPEWLRan2eo+pJR4Td1OI7C6Mada5YqJuQbU/zBoYIrzxUhUZNKZOE2o6b+veZ8pk0taMu21gdtOpKqwpC6mQ5cRof3pSG6wI+FPIJCTFPZO7psuHroXNrQH1Vff1MtIrtoNpKS7Q0XvzPNeXG2vdnnK++lbznaGDxZdS3fOLvgxiKTi/X2oNEwaS1yI7xKYk83uCjvt58p9Gt4x5lIp4AviTsOFR/ZIyFAxB11A/g/lKdFNCSNQUkPLr4QCdJ2gn4d/8Nf9zONtXKT2ja8Lr0yIpnqDT3KFAvpDGbHc/D6x/KJ3IsdH6pW4mQUXv0oSf2lMe78zVL
 tTVrsXN+
 mo7mCbidjcVxoQ4c/7NcN/rBSw3IM47vKx2jlz4BcLXJkI1FI08lvGFtO0bmCxzE28FiwYY88YGtd7HssL6Nq0WSRdVka68XMibYKH/ZAn0fAaz5XhZOltr3A0+5pSoWgRPLcjblgPl/AG/ifJfQL5iPWy//jzShrGrispBjTmQs/niCOyvLj4SnqrBO5j0Ywyd8fQFZRvWpQ+EunJj+shP1pPt0Dn0U5j5BRv2V1+8Gi+F4DW2nhK6iVfnWqaki5HlYwcLgkcmeixb6hq5XAc/xZUoXr3dMCusC1zGj7DKEKqjYIR6hjBicAPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 19:47, Tal Zussman wrote:
> On 9/9/26 3:48 PM, David Hildenbrand (Arm) wrote:
>> On 9/8/26 20:20, Tal Zussman wrote:
>>>
>>> I have a WIP series of ~30 patches converting much of the remaining page
>>> users in f2fs (including the below) to folios. Still have to do some
>>> testing and clean it up, but hoping to send it out in the next couple of
>>> weeks (in the hopes of eliminating some more folio_compat.c functions by
>>> next cycle...)
>>
>> Indeed best to wait a bit before flooding -mm even more, it's rather a lot at
>> this point.
>>
>> In the context of this series, it would be great if you could review whether the
>> diff I proposed would get the job done, thanks!
>>
> 
> What it changes looks good, but I would go a little further.

Thanks!

> 
> There are only two more users of page_private_gcing(), which pass fio->page.
> Those could easily be converted to folio_test_f2fs_gcing() by passing fio->folio,
> which is in a union with fio->page. That would let you delete the
> page_private_##name() implementation in PAGE_PRIVATE_GET_FUNC() as well and just
> remove the entire family. At that point PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC()
> could be renamed to something like F2FS_FOLIO_PRIVATE_{GET,SET,CLEAR}_FUNC() and
> all of this cruft is gone and folio-based, with no more f2fs use of page_private()
> either.
> 
> The renaming could be done as a later step, but I would get rid of the accessors
> as well in one swoop.

Yes, either as part of the same patch or as a separate patch. Zi, can you take
care of that? Thanks!

-- 
Cheers,

David

