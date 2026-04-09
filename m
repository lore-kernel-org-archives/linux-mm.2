Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B087F364A8
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1936B008A; Thu,  9 Apr 2026 13:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8926D6B008C; Thu,  9 Apr 2026 13:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781216B0092; Thu,  9 Apr 2026 13:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 695316B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:31:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 282951B5D8E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:31:52 +0000 (UTC)
X-FDA: 84639710064.17.01BC585
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 63E224000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:31:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l9kMZD3a;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775755910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KM8i7fgUnoIJCsmS4uJHwdc0MaNfBiHD/90iJ+CU3K8=;
	b=0F/VviFmNm2YZckNOkpFRvK01YeGcUrlojoKhw0BWw7zgK14WeNfkOhmSas6XsUBE/IVB+
	MW7P7ynv8+40S78ixSROzm/eEhOGSUDVbgDfrnGSaDiLThiBtD1svq7J+Te9irKeRtjBYR
	KTUk32s9JVO1yFPRt3wWqTw3my2+oGc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l9kMZD3a;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775755910; a=rsa-sha256;
	cv=none;
	b=tTCkCbkFoBN7PYqm43z/x1NWmXU5vw5FbxlnO2KGxMhPSSAag27tlxnUhWESl45rdRSl9c
	VGLxJqTI54i8NDPxoGdFDV/UlNADTPyP3ZwFBerUFbQtCi6913y60WTec845peUIFg4KF2
	vSc4MQAlBEIYcI8E7fS9Y4Ja2BYBwRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6BF5600CB;
	Thu,  9 Apr 2026 17:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C712C4CEF7;
	Thu,  9 Apr 2026 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775755909;
	bh=jX6P9KxSCzEYNVlu725aQwbWeYTWG+BOsJOPtec0kQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l9kMZD3aeiJBKU0WkHAx5I6MX+3fTECuET2RPs5ZfkfhBFFuxuups0ATW43dLBgfr
	 MA8SuwN45QMbMDt2MLAYDHXWuuWapUDwbzv2esKaalR3SKu/TwKPNUqrH33OWxGsSh
	 a9T4iaWnbVHCc2mvkCyJnA9Pu3HDtk6DoM+50EtAYaFDL2bGDlibekBeSplbGJvq3e
	 13u6gzvS0jMkHy6Yo5iyQ4dr1cAsqT1bDrxyrbNSNQS7we5WDNvo7SbZBeotCeeWBp
	 3flujOFuDIj7SnIzZy81DXRsiZtDTiuz1M4VUHbNUKEScaOelwuMxptTNG6Wq1mXI5
	 PuQRzHQGGhXaA==
Message-ID: <794e7270-c91d-42eb-b2a6-67929198a1da@kernel.org>
Date: Thu, 9 Apr 2026 19:31:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <D74E0809-E673-4CD0-84DC-46CBDBB06F03@nvidia.com>
 <accf843b-ee4f-46a2-b187-a6d8e4115ca7@kernel.org>
 <1A7433E5-C8C1-45EC-A0B7-2BDC7D065B1A@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1A7433E5-C8C1-45EC-A0B7-2BDC7D065B1A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 63E224000D
X-Stat-Signature: abq7tfdhaec4jazbqtaqkpgxkz8m1zd8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775755910-235745
X-HE-Meta: U2FsdGVkX1+NTPpUa7EUmF7ZUinXxjOv5yFOWOW2JiQ+X9wZMxjLub9GuyVUJjXiZwnOpXpuqcbIIktx+gz8ASBguXVCrDf3aV1WAUzoW9NSQJdNQavf1V3VtuSlgbYB/G28fdfc5jvpsD3hK+xqkI/fdN2rmc0w27nzBfBREai6PnZWb6VYoZNOFsBiVX6Oo3Sq5bepCOMWtwh0RxUnnkLEpEJhE6JZ/N+HdT9byokm042wRLKPVHZVOkbCWCmq8ASHk8ZIVF7Th11yV/g1z5pR2BjLy1xjsY2+Z/qugi3JzBMHCZ+/jlplbaBRIP7ySm+rmHnCw8S1GoytanfKifGtgyfgDjsfHKjemoEl5R7hI83/dZWeQG5FV0C8S79R7UFCCOAePhleoZxD3ernfC6OIR6qMVqLA0UqFJjd4p3NQMVDcGNvBH416rcrQekDYi92vBzrMCHHDMDpOuTxgwnXAyG8A2wlXLy0WNWz4ahI73H8ayhMhy6JwaN6JbfWzwYVKMiudEKQDK5GXEdvsNnFeK7C85Cpc300u0SgXy10GhQet+9OhOGs5xPpWK/nIyKlVKYEPkvk2HxTVLXkckSHUVBT98aWkuL+6MNJnXXXMJLmX2V99dZRThdu5t/QtFjoXJ8enVQE6mrt2+kigFlFNmxQl8T+Dow7basRjNYzGzoLkHeUVP2D0QRvpvdKfDA6wxREMcdCO8Xjc0+6NsrjnYk4fW4U0teo0z6j36TSNmMbZHG9pyucgZTb8O64K1xn/m+Qyx+NSpCf/7iRibA+bfiXK+ihH1APzp2Lm++C1ZhgO3rxvqpY7QoSymLXi+GL1NMl//iNQlAszFInzPInnSUie/Uhh3ppawbMI/8rkUk6Akt1jgKSQT1oAHpr9MjZ108KA2GB29E+OiIijQXm+AmHiT6JE3mt/+K0ptj3gbLBOSGhrR7MTUbZ4GHqIhMBs64ogqMV1BOClf2
 30TjSsn6
 DA8aaNuecP/4QmEon/kWYypnlL/mI1AWsb7gm3HKXM5by8o8GXVgZ4Aj6PaWFB77wn3FEhwHbQdFbbaKsSOpNAvmysDCc/eKFCBZZ1dT90Qd4o5RARAMcCAzquf52cdFqb68iyI2+3WBSdG72u9GGeRdhttAjwc8QAFKnlbKhc8hNXWMoWwJ0aWOrTVzA8SUbSAN5Wo1/+reahokmOzkPD2lCe6no4V/9wVFH0k0qP9gIWa84SH77/gmWgfwj2RLiNBpI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 18:55, Zi Yan wrote:
> On 9 Apr 2026, at 11:11, David Hildenbrand (Arm) wrote:
> 
>> On 4/9/26 17:05, Zi Yan wrote:
>>>
>>>
>>> The idea is to give every allocated page a NotRmappable page_type and
>>> 1) let page_rmappable_folio() remove the page_type by setting mapcount
>>> to 0, since page_type overlaps with mapcount;
>>> 2) allow callers of alloc_page*() to change page_type from NotRmappable
>>> to other types.
>>
>> Could we instead just set the special type in vm_insert_page(), after
>> verifying that it does not have any other type?
> 
> You mean in validate_page_before_insert() we set the page to NotRmappable
> if it can be inserted, then in the rmap code we reject NotRmappable
> page/folios? And NotRmappable will remain until the page/folio is freed.
> That should work. So the purpose is to avoid setting the page_type if
> a page/folio is never going through vm_insert_page()?

Yes, only these non-folio pages will show up process page tables.

We would add a safety check that the mapcount really is 0 (-1) or
already the proper type (NotRmappable).

Rmap code would then simply skip any such thing.

-- 
Cheers,

David

