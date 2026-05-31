Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93965CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 19:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005536B0176; Sun, 31 May 2026 15:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1F906B0177; Sun, 31 May 2026 15:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35126B0178; Sun, 31 May 2026 15:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE5836B0176
	for <linux-mm@kvack.org>; Sun, 31 May 2026 15:29:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5470405A7
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:29:26 +0000 (UTC)
X-FDA: 84828703932.16.00F5523
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 23DEA140002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:29:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFXG7Gwm;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780255765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qu2+WTwuJ2gVSCxV3OmrdSWwWtogPX4uTQ5dajqvUVA=;
	b=aMWioXbaZ7Ho2NFTZbjUbDLGhAPDZA8HHUw1YfcdPxPFSyYikHlxhSpeRuaV530vtEBru5
	quEvx0QJY1VceJ5/t+MnkCWYaw2J/Sc/in8WyPpx/G8DxKcWSXKst+qeEeKDyxRnvFeN4V
	pl9+E78CXrxFklA6cpzvPuARdg9eSPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780255765; a=rsa-sha256;
	cv=none;
	b=pmkmWme9vLJIvxADasawA/SihZxyTPnSmCBRXMmAmDRJJI30PM3We8Q8FBguBEmsZSOrFU
	/kJ3/ldYi2PAEnQkx4O/gISVDFu4jTvxSXsKJXr/+AU8c4crQJWOYIy157xirPVhsfu3Ux
	glfq9Lnvpt0GZDN/UHA/PWGY7PdruJc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFXG7Gwm;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D7D841762;
	Sun, 31 May 2026 19:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3D61F00893;
	Sun, 31 May 2026 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780255764;
	bh=qu2+WTwuJ2gVSCxV3OmrdSWwWtogPX4uTQ5dajqvUVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AFXG7GwmXhucIfzukLXOgDvZlVmnV9j9ty1ByoXrpRN1ioDyphHHOHlrVv1gakqUg
	 KTlxAHcEq8++l4cHTAc330eModcJymsBYpvtBM2qCbji3PeNjnKxwNrdqyii6EH3K0
	 FhzHHvfdF2Kjq+f8G3BnISidcHkCMQLL93qInxxEkHqXghsN3WFRFDy4CNl0Jte+K8
	 6UMNMQnhTlbRb9LZOYQFes0x9AaJ+T7wRMG6KhTwmG87PnXKQozeUgmUGGXvhbjRd+
	 HcJl+37dRYS5su40Rb/zEoPXIb6vDzDHiWzLnciUTKCGNF8vZQ+/S2JO2Dboz89Q/M
	 NE/JwmRFRRunw==
Message-ID: <6f6e6998-7dd2-469d-852f-4ff7bbb768b9@kernel.org>
Date: Sun, 31 May 2026 21:29:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Vishal Moola <vishal.moola@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com> <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
 <1be38262-53de-4a27-9841-393e12fc1475@kernel.org>
 <db11078b-a283-4717-bed2-da56e77c7132@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <db11078b-a283-4717-bed2-da56e77c7132@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 23DEA140002
X-Stat-Signature: iziyn19tg8733kcdyhdjffy8m96s3f6i
X-Rspamd-Server: rspam06
X-HE-Tag: 1780255765-447720
X-HE-Meta: U2FsdGVkX1/5OE6Dr1ClDeYDEGnhbcffsq3pApK+JCsY1Z1M6la1zRuvk5ZjDAuC+BtyhUoB89tJ3YVSSJ9ybHJLBSSFh5yI2sXktRYXBtSZmtE0yDxrAynrrdm5KX1EpbRrNGDAbBY8p1zUm9Ij/nt/PZNYID0tVOjnW5PQdyC1v1/z7YBdO19Y2jz7WE5kp7J2O9zr5OWQNYJ0tnHuiwcqf6+k+H+DtRXge9RV/D67VsdwA16aGi50Avz/KdFJTlTa0b8K1nWZWCOpZOm36RJMuUDym8ziLW1xSxG53jo+EVmYwGiO5O2lDX96A0JVhG7c+OFEYNIS+HIy3qfjtpdED95SKzZ5o/69PsbQz9A1ujSXa0eVc9lIO9RwjrvprzGmQKO4PrNIaxe/f3webYfkN6L8SqZo78xD5zsSzBpWD3PydGzs5wgkFhgWOanOSRHYpkOGOMG7NYZ4RwFle99hPoBuem1cA8lZQA4ULdj11yfukfYNW/xFQ/Tm3NCCYo/s2Hc3S+kjbb5B5pg2KJbajjQ++ieBpSJbpe2vGCEmbH1ftyndwCVi6swCU8oryxXK0Sv4pj4wX2hDTpQ7s+/DgqY+gyBgmdo+JiSpe6IVTi40sphL0aGpMqsL7Og/o0xVYpvWK9pMRllDKFtZLvybpjqVZPKPxjGrBp1SXSgjKrHjQMy9vxhCRtB8FqsrlBuQzMqaQZfHyrWxCBBJpxEthAhXf9Kw3x8JddqkpdYydfyD1OHCxHNIKYfNpzP5MCga2Vru41lmkrCwVyxmj+cjKlsQVKmUNeuGjD55ZCICVlf1XG0FriHBMoDZ/aeYw1RrBbCZm7GRqNgnc3pDoX0kfWOjB+r6oMaK7CHaAT2OiAnhZdpFJd0N4YlR//bwb++P/4EBCXF5OL3TSi1wvDwSg1TWjS+jJXXR96DKoLifYXaE2HZUwoW4kLmb6kecKFwifg7g3z2WqEcIJlZ
 KNTL0ZLu
 Z/iKLOAhyUNmqK/DYzDh1urn62RFDCAPW4fdVXrTQkRAxOlHW6nQVX7ZCsXm32eyt0eXlPoATAArbem767jn3nyORTR+qe0FXWM6NErYcjiAP0KiXYo0+06jz1AryMrsVcJgbAyqPMEwLBbkY2f82oyUFyGsuq/HPunPNCozjmmPTBxso66srsD4tz5r+LKlycGSKdoeiRU/K7pi+FC6W87TYHb3dk4KHm9bgfGOLkzWGw0HngP6Mzvzpo8RXwUZS/GkQMdDgNXLRoajc4p7r4EA2+hZaeRLsZgaeFdzSccVdTBxwAbRxbNWid5rsZs5vpGlVaw9dOoyUo7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 09:34, Kevin Brodsky wrote:
> On 26/05/2026 14:31, David Hildenbrand (Arm) wrote:
>> On 5/26/26 13:54, Kevin Brodsky wrote:
>>> Agreed, I think this is the right thing to do, something like:
>>>
>>> if (folio_test_pgtable(page_folio(page)))
>>> pagetable_dtor_free(page_ptdesc(page)); else
>>> free_hotplug_page_range(page, PAGE_SIZE, NULL);
>> That code pattern is wrong.
>>
>> folio_test_pgtable() shouldn't exist.
>>
>> In the future, something is either a pgtable or a folio, not both.
>>
>> So check the type against the page, not the folio.
> 
> In other words use PageTable(page) instead? Interestingly I can see a
> few calls to folio_test_pgtable() across the kernel but none to
> PageTable(), maybe just an antipattern then? The ctor/dtor also use
> __folio_{set,clear}_pgtable().

We started running into the wrong direction, and now have to undo all the wrong
things we already did :)

In the current design Willy has in mind, doing a page_folio() will later return
NULL if it's not actually a folio.

-- 
Cheers,

David

