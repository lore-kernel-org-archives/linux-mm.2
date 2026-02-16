Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63704E63F3F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 09:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82AB16B0005; Mon, 16 Feb 2026 04:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D89D6B0088; Mon, 16 Feb 2026 04:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690306B0089; Mon, 16 Feb 2026 04:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 544F26B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 04:07:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDA7C160C4D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:07:09 +0000 (UTC)
X-FDA: 84449740578.18.87D1E4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3CD7CA0009
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:07:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FYvIch1U;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771232828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaVHGjBQIzbqiGUfwMg52jVCGhg1VKrTcd8VIAf0FsQ=;
	b=LJ/p9wYad80qxIopRxsriqDuwtF7se92cMXG7MHwj+QI7iJ9FrOb6TOtkpw47yHTf+4Dkl
	7UQ9ZjEoKLAyL7uO4QvIyC4K4vp3sZaIUEtpzIG/9LufB7b2fsqpQRn+tcHGmemv3hDpfx
	aVla6cnj+S+lRlRNSxthu8M/RldajqM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FYvIch1U;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771232828; a=rsa-sha256;
	cv=none;
	b=oHd33Z349idooY6qgMrNacCTQjY9DsZrkrBf2A9Zni8HZ7gsp3QATAbWlfdUpBe95Zha+E
	eaYNdA6cnA+BuR6sledxSBZ3rI0J4yO3dDQ5FSMtSQ62euqu5Rdt51QLpkJZlYx9OulpLM
	YcOTe473pOegGDfTwSeN+xH9Cj7WqvQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B6DB600BB;
	Mon, 16 Feb 2026 09:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C93C116C6;
	Mon, 16 Feb 2026 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771232827;
	bh=Pn8iMDIZmzFd3kkBcfiQHX1j0BjcMGClm/3MIGwtj78=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FYvIch1U38DwPufVNrBLBAbn0caX9A0u2fc1XTx+8xS4GM6lbSoz0aK6WztCOQhgu
	 Vx0h8p4NW70I4RYvdbzNN3WeCbH2veDYorXEU+XuRnOO2bBGmDyuj0HdvJ0UO9NapA
	 WMmllVlT3Sps3rZOVIgM21JGVU3rPlmkTd/PrNsaqsDBCNcKojNsZ8ARxqvwtAxRsI
	 TgoqrGz+UUyTZMy5qOlBHvr/5o0DCg0PWIfE7yqHUeBhz0YnA2tbX9c9NMxbQZ18nI
	 H0ZFyO/ROTLHJ/Eh3O1IjbDs9b2IQPw4FXOY0/N4Vsc9RofntPgvkSjl5odPTVBJV7
	 RbqdaQo9YbeBw==
Message-ID: <ec4a9a1e-8c08-4879-a787-3b9e0bc38160@kernel.org>
Date: Mon, 16 Feb 2026 10:06:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
To: Matthew Wilcox <willy@infradead.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
 <aZJTLwV2SaaKu1k_@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZJTLwV2SaaKu1k_@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3CD7CA0009
X-Stat-Signature: qw91x9xxw4ekgyrzr3k6bzb8qdpdqrdz
X-Rspam-User: 
X-HE-Tag: 1771232828-830414
X-HE-Meta: U2FsdGVkX18LxP3wnjQsFmSQAGpkBSVch46BZ2EaNDeOa0pXIGGbOdEf+NoaulWK21nTJLUWYhWbZ3lRAbqp7/sHw0y7091C5XwKzv7BGe6vHuReAmpe+aARZ4fOlH7um82ZgzxLuYv2E4yAxJeeZRApczXSH6obKARC7OnJ2KFX+SipoOpEYcb7QGmcCvKDZ7qWgAZWQXEAeHlbkCrrjgDZeON/PhHTElaMp9nQoHLbl6TntSKRLIZieUsxBo4YfuOi/bW6BaZs6/uPHoeJbm35wO3sK+iA2auHHCtq/2e3UBf+AC3RllkhF/grQxdJs9Jd/W36IjulIAZW8D2PIuPJXNowd9ozSUAd9VDmLzQ9EZwvRuTuDsag6debsYxpF8CVVpIAP2Qgd/R25nnZGv9nZIa/8bHndvpWlbCcdnU9fM0YnalICUjfe+W07jVSVNf39FRcN576Y4cwWmUZx9w2nEHMpP0Kq8+5ctkLgWgMI6uM8dQGSGRlaKdppsAN5+xzx9UyddT/BsM+eLrCEXxANNitccf2kxC7FGueEhrG332sqK5R/LTpn6JZAPBBxV0D23d8fmQGQQ1bWijcVscNMUEBPYLU//5RrkaLFcrflUmUDRGT4fXdx5wHFbtvU1GfJNOErrxaw3m7w1oG6jw7L8D6ND134+j+RbNOaKsp5FqoEPe2kvivY+a1jc+NVXX3UBMKjfdtQ5X8fwSJK3+bSZ2KpYWFmEj3atG9g0bFR7/1pu1BL/EBR7fgJgycV8LXu/xHJZJE/i0yiKo9Ei92+mZr1Yp4ST2MI0m5X7yJkCwq9NUzhTCFi5ItV8OY7YetVqG11su33VPfvthCp5xzTp7IjYuNg/bs5cOLAnspNzcqu+CYOGXOPJR9446sHZsFEvCgLnBW0V9bWiDhloBYuODU4GejtaM0tlOLDUA2ajdNgxLWcQnxSDyI8rqthkIdz04fOuwda1K8M/b
 UYWWJf7M
 TnZMk5VJw09YTpRlmYgVJnWaIqOo/LWMtzUozmJIt/qDGhdTvxzks8ROb+fozmir/eEyn1+T2lWeicN3Xezmm0m4Uqh/DwDdsXfS6gkKksXKJBNvmkGmU7cdU7+HfcRrj6wa5Eq9Fnia37JgcS4v5SIxpmKkDP8flpjhydXJwpyfxFC+qXCBc5jQnRBJoXmuquaWxRCwL7gZq4z16amtm41puf1gcTj7rpMUq4UMcaSFPIs5MDiExLA//31IEHKOjjO5RI7U4evxuvi8cGOywT+HhGZGtCHUZ2G7hQzcr5sfdHyPRU4Gt4maf3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 00:13, Matthew Wilcox wrote:
> On Mon, Feb 02, 2026 at 03:56:24PM +0000, Kiryl Shutsemau wrote:
>> With the upcoming changes to HVO, a single page of tail struct pages
>> will be shared across all huge pages of the same order on a node. Since
>> huge pages on the same node may belong to different zones, the zone
>> information stored in shared tail page flags would be incorrect.
>>
>> Always fetch zone information from the head page, which has unique and
>> correct zone flags for each compound page.
> 
> You're right that different pages in the same folio can have different
> zone number.  But does it matter ... or to put it another way, why is
> returning the zone number of the head page the correct way to resolve
> this?

How can a folio cross zones?

Runtime allocated hugetlb folios from the CMA/buddy (alloc_contig_range) 
definitely fall into a single zone.

So is it about ones allocated early during boot, where, by chance, we 
manage to cross ZONE_NORMAL + ZONE_MOVABLE etc?

I thought that it's also not allowed there, and I wonder whether we 
should disallow it if it's possible.

> 
> Arguably, the caller is asking for the zone number of _this page_, and
> does not care about the zone number of the head page.  It would be good
> to have a short discussion of this in the commit message (but probably
> not worth putting this in a comment).

Agreed, in particular, if there would be a functional change. So far I 
assumed there would be no such change.

Things like shrink_zone_span() really need to know the zone of that 
page, not the one of the head; unless both fall into the same zone.

-- 
Cheers,

David

