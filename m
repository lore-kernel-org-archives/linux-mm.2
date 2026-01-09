Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD893D26D69
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7F66B0088; Fri,  9 Jan 2026 10:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C196B0089; Fri,  9 Jan 2026 10:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161206B008A; Fri,  9 Jan 2026 10:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 066B86B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:24:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C43556B64
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:24:48 +0000 (UTC)
X-FDA: 84312797856.09.470779C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BC331C0002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:24:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pU/2H1dF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767972286; a=rsa-sha256;
	cv=none;
	b=JnRK5UohpBW7IRgskbwkvkTsAI4gBOlsPeqZckrXIEoNOV6/a+Nhubc7iKym9tBuTGxSBQ
	KFk4mmlgCIdzCP3iuD2xAWrwmtkxLdkhu8rzY8Lj6t2BlnRHs1ZQaq+PR59KZARlKmSRAD
	xdDhR1Vw8YiwNGlTV1/meBQb1G0RQZQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pU/2H1dF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767972286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jr519NhIZ8nfRVS4g4szsjBfthpQD7dsETmCRLPVmI8=;
	b=O/Qk2SQThUYN842pyOnl5d9FRI2Z3fkXS6z9JUMc5s6R+8Ht5RUcqAnWhIEIufCWtujXRX
	pTh+3Oi4Axkt3MobmcZ49KZJ7IY6BcOAaRR4UKhiSyIOGWPd0SGBjCmnt2A8ENun61MOmj
	J4orXU/ffQbScuUIvXJE57GdiRpg5gc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC592442D4;
	Fri,  9 Jan 2026 15:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D52C4CEF1;
	Fri,  9 Jan 2026 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767972285;
	bh=axvy6DYVP2agzRnl6Zhjb8bX4J+s/WNM34OMhZ6lfpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pU/2H1dFfG93kpEUPYu7w7/VXmb/gCiR8gQewSBXnKe7C5c4PF13ehhOoFbpYoyja
	 WDQ5yuTteGs4Ne/v+LHD95mctIe9ZXiABGUWlCzbI96OatJTh7TUC2kQfsTcrOCQ5A
	 MnnrqwAX2OCoFXiTaArGYxiyC+ZVHKSfJpXYF+s6ARfOY1q/4/Ol1fMvuk3t08IIsM
	 WUIczW4dq6yEy6fGrE7HUFUa8zIbX/aucAWzmld+iwpa5dguBZr9Ec5tQvYJoMQgS1
	 VzubOeshaPJ9CVip+imoA2w5haEZAr9lrvKJ3KXAjL3LjmYBB/16YrhPKpjxL5W8ie
	 Kz6tThsSMaS1A==
Message-ID: <bed4daf8-9a35-4a88-bb35-2f178d8afa73@kernel.org>
Date: Fri, 9 Jan 2026 16:24:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
 <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
 <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
 <yup3hvfsn4tvfnv32mdf4yoabt4igb2lkvllfac72g3abdkovm@auqdaijzby7d>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <yup3hvfsn4tvfnv32mdf4yoabt4igb2lkvllfac72g3abdkovm@auqdaijzby7d>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: px78qta81996aio9oh66hq1jbagnuxgf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC331C0002
X-HE-Tag: 1767972286-524879
X-HE-Meta: U2FsdGVkX1+A1No8XF7/BwvaFDKUaOUwcnBuZQyiLdbkplvi+twsoeg+nMbyGgmEu54bkoWaTNAlrnolV9EhrVkzuaI52Knh/vGirGmwP4z6z9dWhyfoj/7CuWUe7xeUeO1CA8/kouIK7T+bQFa8bHd1V8JxH+VK19RqMuID4+LZ6FwWb1IgeOt0iDJmnxc+ADHN9rxlK8h6KHFKoSKd7eTooIDWGngNbtRm8NASu++eFIuRZ3wy9RqahchSGJE8Ew7V9g4YoC+Fo185s7i/CHhto0bPx1K/LwQMdNeBgoCkFkyCYoNqZxiEJ2maLHlBGAGMzqZlxsYnYh5FCmyj19p7IV8fcvUpTUA1aycAzdPTTYnYGrXcRNn7E5blOoUjSrGvOUmWMKV55GZaoCnEbSU/xCJziCSQUxvto0uGAktVhHaJZ8IOsrBQWSyKbYkf95JDGckGX6vBBzN2YtxvHfran2lrbUEiuh7VXBKyflXKq9qFrG/+WcEfXGthjdSz1YySPImEC+JnumgayS7S+OuwggwPY/DF03NFyheBfHjLQzXtEr7GRpX9FZRX5JIK+OYtI/YisZLfvzduChtjqufD9Bsf/bz7U5uzpPxqR1ZW28gbUn4X3EtPJJriBjIvOUQbh9ry+PRp3/98JEYg0T1pbkP2mWBWkk1wQqC3KyOvATrvlUj5kOYbyQ0GYhKcxDd31KpSqkhwG4kfE6Qd3PMg9gsCeClVvvsABBPMTdVSReyj6PKb6+MIv/EpVgJCveq75oV49H5cy6p79/CixSfljppYQFj2r5mIntU3SfHTr/rl+xZCYz8GQtMBdP7CdQ4jX4V2tc+WlHlica4Vmqakw61DdZYS8HD9doEDXG0CNxgH5no/EiG+jgw5ZOr1y3GNuWoWaYFbk6w24Syy/+HR2U9zVNdSMNJRmSiNVkHXbDo77E8a8XhOY5+QWGCwC0F4bGV2mcBwzdc6A4e
 D7/riCzw
 uEuOWADEEiAT7k8RfxliulhJaUVZiI1eCcCyZP5IroCWGoMlSSrgJshLrpUiUtFScnrnlEh5rtQEMqBMLSK2CD+ZGN1YGFXIaZEnmQo2Mz2xi4h7OLa1nQxqGiWwbcKSeiUbud94j0KZWZwHKkUnwsZgwcqo6y1zKwFI0SaRroSyFHhrrfsWf9FiKxk6T1PnCM2W6E8MILvyJ9O0oe31H1nGdEncgjWJTvqD3cmhTw//QJpqv3DVtBk2TntBnSu9v9mOD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> For quite some time there will be a magical config option that will switch
>> between both layouts. I'd assume that things will get more complicated if we
>> suddenly have a "compound_head/folio" pointer and a "compound_info" pointer
>> at the same time.
>>
>> But it's really Willy who has the concept in mind as he is very likely right
>> now busy writing some of that code.
>>
>> I'm just the messenger.
>>
>> :)
>>
>> [I would hope that Willy could share his thoughts]
> 
> If you or Willy think that this patch will impede memdesc progress, I am
> okay not pushing this patchset upstream.

I pinged Willy.

> 
> I was really excited when I found this trick to get rid of fake heads.
> But ultimately, it is a clean up. I failed to find a performance win I
> hoped for.

I think it's quite nice as a cleanup, and if we wouldn't have memdescs 
on the horizon that essentially change the code completely in another 
direction (having all pages point to a struct folio, not just the tail 
pages), I wouldn't be bringing this up :)

> 
> Also, I try to understand what 32-byte layout means for fake heads.
> _refcount in struct page is going to 0 and refcounting happens on folios.

Yes, for folios.

> So I wounder if we can all pages identical (no tail pages per se) and
> avoid fake heads this way?

That's the ultimate goal, yes. Essentially, all pages will point to the
memdesc, and there will not be a reason to check for head/fake-head etc.

I think initially, the compound-page concept might
still co-exist for some memdescs that we won't initially allocate 
separately.
But I don't know the details of that.

I know that the transition phase is tricky :)

Regarding reference and folios: yes exactly. When trying to get a 
reference, we'll spot in the memdesc field that this is a folio and try 
on the folio instead.

In the future, most pages will either be permanently frozen and not have 
a refcount (e.g., struct ptdesc), or have a refcount in their memdesc. 
In the transition, the location of the refcount depends on memdesc type 
(in memdesc vs. in page).

-- 
Cheers

David

