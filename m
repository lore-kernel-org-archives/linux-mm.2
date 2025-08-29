Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652CFCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 00:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2CD6B002B; Thu, 28 Aug 2025 20:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BABD6B002C; Thu, 28 Aug 2025 20:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFEC6B002D; Thu, 28 Aug 2025 20:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2A56B002B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:25:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0542C11920E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:25:35 +0000 (UTC)
X-FDA: 83827901430.10.2C26030
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 25B8014000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:25:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/oWKLrG";
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756427133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qEiRJT6L0KlzrHaKsBXIek2jdzMCUk5kk8Lf8Edofk=;
	b=OOVbovgeRav+7wSq1TJhvEeF7zo1eBPom2/sPljhO4B87wQb+DylXJrSADBHbzBDoVTXPK
	o9+DnY1fTdFJTFifTNbO5h4Dky/In3F1SHS8TKZPKKBXPy8Rhrx3Kv89PcknOgYH7SFpQS
	CXoNnqYyliu9AhW5H48qEOQ/ECAExAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756427133; a=rsa-sha256;
	cv=none;
	b=WFCazZ1swR9haM/4YDOqCrlVSH5CpClTcvUHGz1SxjqOWkBboQWEYP1iaBk3NLXQ1iNNWK
	hgthB5WpooIt8h7+PUZGbXWmn7knF6lucS56vV3tFvFb2JTicpbtH+R8QwtBsEWhzd9Mig
	0wV+dVK2kJ0Y7MEbS/PfxokU9JSGlQI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/oWKLrG";
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA50844450;
	Fri, 29 Aug 2025 00:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DD3C4CEEB;
	Fri, 29 Aug 2025 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756427131;
	bh=mcyLCjBm9bl4ZY6mSMuRJ2uZCphNIYGX7Xvto/pbXbA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u/oWKLrG9w8tVTD1fZ8iHMCTnvOpAvWDeHA6QKVbOxI5z3EsWkKOYpx+/EqygyXxT
	 JfsI9TgIRVHKumF8STASk0xFgWojfw7Ae2CzWwD/2Q2uuHXJXzQ2WP0cdMy2yD417H
	 CsBjZQp1WYO2XyxCtl17k56mMmCMHv9CfhW9EaopZS9VGhmJpwlMecnpjR6PhtJ/fj
	 GrN7kYbeVhnoRdeSLtAXW1b3kHoiS9DAKmAaknHskX5SZxQCo9ZS9tNyBpYomI4Vyl
	 stc7Srggmoj/YULxsLdMf7tTageVur4W6TC/Wx9ff7SP+zxWQrvIoTZdLNEPK/uv1q
	 9GQe8IoL25fMw==
Message-ID: <423566a0-5967-488d-a62a-4f825ae6f227@kernel.org>
Date: Fri, 29 Aug 2025 09:22:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 24/36] ata: libata-eh: drop nth_page() usage within SG
 entry
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-25-david@redhat.com>
 <7612fdc2-97ff-4b89-a532-90c5de56acdc@lucifer.local>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <7612fdc2-97ff-4b89-a532-90c5de56acdc@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25B8014000E
X-Stat-Signature: t79t56n3jfzden6438nfzh8h4gxij35x
X-Rspam-User: 
X-HE-Tag: 1756427132-694931
X-HE-Meta: U2FsdGVkX18KWAcc34dvitF0IsPpDatHtbuAF+h/I56JkgNy7zCAzV7s7RAODPJ/KyU+ZKO3T/rBPYscm14MP/YxfKMWNk0piLf4QjBX+NXVeuPLunMRB/hrUjp/Q7zxCauyz3vNIIhuA5OLzaf4grO5Acc3vdZoX9DeoPheN81lcP+d02kGC2t7Q5LgF2DMA8cmUvYvjJAwxL4xBgjYmQXRvAPAcY0SlHFpOE2hPIvvRo2nK6VYdwmxeR+n1Q5lhpVtqz17Sr3hztpOq81mxeuZDC48dAT8OV+ElD/W7+c7kSygm7F6h0Rm94WDQHouR3xFSbopIKLBCxqaPTYaZTeigc/unlzORQuhwYH0SIi/e0EvGlqj1yEy0DnoCA7FqYE7OMdMtEmZG89QIrz4iYikXZjs93ceKxJShIVi2CtoW62haSHDxcK1nHKuXrwXDhcf3rxnflhEER6nfJ8RyjB9MrXzjHXTHBzsdvvAwULRS9mcoUO2KPvH9xLp2WPF9Soata735z1yaRmaTyqVv5BqqCn/06Rzi3SxKOC66lEdT/KkRoOZtOxyK7Nc4NFHkKU2a+u0HBoByfmUwFjZ822HjBFyd7o/4D1EUq36JMwLABxyykMQOM+KJUmNhO73dhxL2siA86B4SlHHW0MKniPO0+YaqLYayG3k/R48Mig4iCshCMG0um33bpUycieCjyqp1Yb0Wp2Eztz6BgmjtTQy8Wtp4luCSIML01CJJy0izsZUj4EV/Sgl8gOX3PlckOkKst01dYwUpmOrt6AG+Vnj46q0e1hIVj7EwOgx3C5FlRtm9FgGS+jtbajnhYpDLK7taG6e2ozQiY2LLEAdQTlQjfRYtnImvS1n+CV2jVriwz6+5yw4S9RKn2hyY5r73LxdcOP5Uz0yljKSPdOgun/zKoWFQ4Q0xBg1RQKlpg6Z7ZF+VWRsVkKS571txudM82WeUxJHxmdvSpPl9BD
 HXIOeRJ5
 fv9gz39f1mMlQmjrOF/ugb3IGv7zVaoqJyoIRl/YSDOFdoVU09BE+USA9lDnAd1Xrcjv2j6XHbtTHmdcYnFZxSRWiZUqU1FljmOZ7ihsXH2IxGktvQfqFKMTR2Xk4PzxN6roZIn4Vhn2VwvreeCi1w3cl/mqE3cl6Ulr6y+7ZH+4q3xPEXuZJRGxUftFLjTU9S//rWOyczobeC8/0LN9v07WS1ydR/1Gbdf8tjr+yditUP94m3zxF6+Ue/jptQug5Yq/ipuZGoq2ukiXHcB6HuuHUQElO36wYlW9HLqcoyG6Awwvtq63lMk25uprYwjLwmgpcpTVj+rKuo3Fxt31PFz/scABkaUQnhClEmIHoUp+1IvHJYJoFSIX68x5I0RfPgKcnkLNKyEc1C5xduO5sWGmcVK7wg+cbyYW4vNm8nr5kXkMag3Y8wkN/eR8XPu/Pwlfh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/25 2:53 AM, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:28AM +0200, David Hildenbrand wrote:
>> It's no longer required to use nth_page() when iterating pages within a
>> single SG entry, so let's drop the nth_page() usage.
>>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: Niklas Cassel <cassel@kernel.org>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Just noticed this:

s/libata-eh/libata-sff

in the commit title please.

-- 
Damien Le Moal
Western Digital Research

