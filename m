Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A396DCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FDF66B0096; Tue, 29 Sep 2026 04:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D59D6B0098; Tue, 29 Sep 2026 04:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475D16B009E; Tue, 29 Sep 2026 04:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 290796B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:43:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B35998043B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:43:47 +0000 (UTC)
X-FDA: 85266161694.10.D7F58FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E01E1C0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:43:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBDwfrHY;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7ZwDHwCgtTpKzG09AoZx3xocuDeXqkubNatC0w4bQU=;
	b=YOhbmg1EvieUnGf2K59EEyXALJwufVLvNmqsgUYsfED9skeJav0Iqri/roCkcKDGVvplQ5
	tQ6O7Bz90kRPywLmJ7HJrB+Ueo9ciTfSP+YctauzRftxp0rMwT7IbnxzUpjgirDWunGOzL
	TDp8QSjnKihtnmwAeTeB1uoSp56EFwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671426;
	b=upnVtkASBFmerkX6u3qKBUibAIa95h1GwfFdji4r/hF1wD87yhH4pIIS8EaE/SJCOTO3+Z
	QQRk2beohBpmSY0cPrxF2p1zzfBntyvZnbmppj4dV2ws4Vbdiq/pCprnAG9I+160q5xNke
	uhMfPOaaYFRkdze3rlzOQuj4kKeOXdM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBDwfrHY;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A30841425;
	Tue, 29 Sep 2026 08:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C574A1F00898;
	Tue, 29 Sep 2026 08:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671425;
	bh=n7ZwDHwCgtTpKzG09AoZx3xocuDeXqkubNatC0w4bQU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lBDwfrHY3inuAoEAndHGXnyuoIoECnFC7ApDC5nXOylkuOkgrKDP01M2YdmnXg7N5
	 OVQw0RPU2+xeG1SBHIkczI/C0AZr5hkyWrVnOhcArSM3wg+KAdakaIIbp7E9Av6qm5
	 SO2BH0ZA1/M9djZtw+okW/M7pSV5/ROKA8jG1f6DsihZo2bMdDT8eVTAfMrnKyaB9P
	 Nal/wms3eAZdrT00IRNZZ2v05dscRFGmcSIZVutDeXgalzyia5e+j8d5rb4Q8vZP9y
	 NWnhHBt9pwDi0reGXW2WIsDjviAiIa7wIRcXC8j/nsq24KZDemVNRxLTH5zQvmhRJD
	 8ldtZ7nJtx4pQ==
Message-ID: <bf153c2c-ec21-4919-ae48-7ff97fe6ceb6@kernel.org>
Date: Tue, 29 Sep 2026 10:43:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/12] mm/sparse-vmemmap: set compound page order for
 device DAX
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-7-songmuchun@bytedance.com>
 <751f6586-625b-4485-9f27-409fdf38bf3e@kernel.org>
 <A77F22EE-0C10-483E-83D6-CC88D8485E88@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <A77F22EE-0C10-483E-83D6-CC88D8485E88@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ymcn8oju1prg7g9xyhnkif6juezogobn
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E01E1C0002
X-HE-Tag: 1790671425-213174
X-HE-Meta: U2FsdGVkX19W82lSw/yICdo4Dku72iDtzw9DIy79Yp1f4wdpgZBy8M9b1tLIe42wiNwvp0mr5zl/P9ia4TfuOaB/AzdiniN3p/7nT2vq0ztqhwc9weORI8qs+SDk85ACiDWxG0Ry3NiY//cAJ086Y1I28xJ5YRztCtniWhRuXLmMg5nCBRx5OqpH50YWYcWQOBHI95QFUQxt4lL4y8Sc1fgJfDTyyluMG9Qt5ux1DtDwN0VYfWkgyghJcO6iXPnGc+vE0RjZ0EL8RdG17Q44WlWC+kzVdzcsq0tXKYp7x73ixJy5AcWIkdsNO+upIamA6ij3NP0Otgo+97v+ona9Jsukp2l7hmYxdY9fDv1xEWmB06MgzAyIPKxp6ThQJ8HSIb1bnYnQAZuVUW1sB9sNQsFS9vsh9QO/aYVd7SZtvMdtglOiglZBJn5ozIs9zGdp9hh38M6pexRXZ9YCfLGYuw1Y7UuEW0W8pwQkog7lsCD9EV52vJXwMnEpTcEzFJye5dIB8x8cX5PwWi3ZWmbrwjEOYJGzA3uwBCPXk9Uq3VfIhBxC37V7EjDz+IJX8FxfYh1ZHX2GaXWLdzUL9RZ3+Srn4EVUGHmH7RuzIA3vARM53Ux/FWW/YFz7t3+sSJH1u3wP8zGhWetnjlAu0zzxo1bXwSaanUZZg1kzeaUR/Gg9OrsFYGa2EoWO48Ne3SIcuEC6M1axiQjeKF23ywXa0dGc0jGxLxgDnQVFffEeMJcXsE29O24tPdpCqa4ddveu9OdsUsyAwYws11k5J67PplKR6ILPfJE/cRmqRpNYNJGwX1xNFQrwPP6zcrUsBZ9Fxon+1q3UBnkIznz1HM4ptFNnL3A1EXqKcOH+7ja7lvsVJyQI+zAAlVicb3SCYs9bWlNH38O1wtACdK/F5289lzNULsBBmhhTO9p8AiEFLm7qCzaVvJq540/gwnMCy+O+kVjCamd3MQ337FzLh/o
 PtYPSWxt
 BVyJxH5Ry8SP1SAIMX+e0sYS2BxUDMdU7MAUyqGYKlwceAOGE0ghu/9fFWL+eIF7nl8NFRmiMASRJL8oOpN880usetEHCexdi2A5nJEMq9M1cz0AFvfDTWXqtQ9zWHg+egtMyCGa0iXfqpawNcgM4ReMGlsQu48WMjfSZd+p2d7x9m0lcqkiu4vRB2854EHyb10yfHtFH6l9ANdoODAU8XwK4CTBKi/PSuhyhgw07fLu1uXMa+4XTf7YbrXBNr7yjDTIQR3jc3PVkMmwi3sNst3ryC2uQUI/fzfMILqCnc8O57d/iWf6dQJCQng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 10:22, Muchun Song wrote:
> 
> 
>> On Sep 29, 2026, at 15:30, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 9/27/26 04:54, Muchun Song wrote:
>>> Device DAX can use vmemmap optimization only when a full section is
>>> populated with a compound-page geometry. Record that geometry as the
>>> compound page order in section metadata before populating the section, so
>>> later vmemmap accounting and population decisions can use the section state
>>> directly.
>>>
>>> Clear the compound page order when the section becomes empty again. Also
>>> reject partial additions to a section that already has optimized vmemmap
>>> mappings. compound_nr_pages() determines how many struct pages to
>>> initialize with a section as the smallest granularity. A section therefore
>>> cannot safely mix optimized and ordinary vmemmap layouts.
>>>
>>> Partial additions continue to use ordinary vmemmap population, so they do
>>> not save vmemmap memory. Such additions are uncommon, and the lost saving
>>> is negligible.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>>> ---
>>> v3:
>>> - Update the subject and commit message to use compound page order
>>>  terminology
>>> - Use EOPNOTSUPP instead of ENOTSUPP
>>>
>>> v2:
>>> - Explain why optimized and ordinary layouts cannot share a section
>>>  (suggested by Qi Zheng)
>>> - Collect Acked-by from Qi Zheng
>>> ---
>>
>> [...]>
>>> static struct page * __meminit section_activate(int nid, unsigned long pfn,
>>> @@ -838,8 +840,13 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>>> 	struct mem_section *ms = __pfn_to_section(pfn);
>>> 	struct mem_section_usage *usage = NULL;
>>> 	struct page *memmap;
>>> + 	unsigned int order;
>>> 	int rc;
>>>
>>> + 	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
>>> + 	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
>>> + 		return ERR_PTR(-EOPNOTSUPP);
>>
>> Hm. Why should we support optimizing the vmemmap in case we fall into the same
>> memory section as boot memory?
>>
>> In that case, there already is a memmap allocated during boot for the entire
>> section. IOW, we really shouldn't mess with the vmemmap in case we have an early
>> section.
>>
>> But maybe I am missing something and this is already disallowed?
> 
> Yes, this is already handled.
> 
> For a partial addition to a normal early section, after updating the
> subsection map we return the existing boot-time memmap here:
> 
> 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
> 		return pfn_to_page(pfn);
> 
> Therefore, neither section_set_compound_order_range() nor
> populate_section_memmap() is called. The fully populated boot memmap is
> simply reused, and no vmemmap optimization is attempted.

Perfect, thanks

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

