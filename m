Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF76CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 12:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3683B8E0007; Thu, 13 Nov 2025 07:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340098E0002; Thu, 13 Nov 2025 07:31:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CF88E0007; Thu, 13 Nov 2025 07:31:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 126D68E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:31:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1DC64D587
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:31:16 +0000 (UTC)
X-FDA: 84105518952.07.4B652F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 11D0C40002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:31:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJvLmW1j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763037075; a=rsa-sha256;
	cv=none;
	b=h/uAa2mdm/NPf/laVS2C9eIicRO+JmXW2km5j6PNtIflPwb2kNu6MY9NLrGx4Puivdy0Rh
	WDxd1ODTgaLevYwQlPhSnBY6fIwjXaMuv0x+V8Q/Hkii4tUkgmnQZ3kz4NneXe2omMt5aB
	A9BVwBOdd2Qfqj5tpE11bWGiebVb0a8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJvLmW1j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763037075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZT7sHS+wdUuxV11KqsG/QCLXZmK1oi43WOee9hVSDs=;
	b=6b/QbtJ0D602KJDjOELRmzQpA8wOvowO+2rbKjO1B7t8ZP2Qoft+rqL6ysyBmFhQAOV872
	Qtm9Gg1HitJnOYB/jwRStY43zP0vJBL1L67jKJfZVyeD6Cnor4ux56ZdcWDEiEoOc9oGKT
	yKdwCq9MXRD+mN4OG4XgxALpTxhHLSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08CB84090C;
	Thu, 13 Nov 2025 12:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFB6C4CEFB;
	Thu, 13 Nov 2025 12:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763037073;
	bh=QNs1OP/Ei5Gj8PXSjfO9NL0jCC1HOH0wbGuvS3cGU9M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WJvLmW1j3xX35WJhkWl9rXyH98dh5uAUDpGhiFCzFBShpOi81JJb2mhrylMAro//Y
	 vwg1KIm/G1EbmpdZge9j0Bt56hSSXgAqciEHu3smzQdwLo9H7rs0ORMOZQeHMDed0z
	 cogLwsH7vSv4z8ua55Hoki4SVpTpQa+UNKxC/6ciT0g4kQOvPksxTFGoysrzWJXfPb
	 KPQjbB40vniM+1cmR1BTe/mvNRqLOo2Nl0O++lRE9GNj0chU3uAwqcLFOVCQ3x5fSI
	 Xyjv+mPIW58F7dvCmN0JBRsBR5hru6kTrlBzxscXW3Jo9nydPuoCgxlIiRjIs0ai28
	 bTx0oOmf3FyrA==
Message-ID: <8c4fdf87-97b9-43e5-8fa8-3bbc9bbe4953@kernel.org>
Date: Thu, 13 Nov 2025 13:31:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/16] slab: Reimplement page_slab()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, kasan-dev@googlegroups.com
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-2-willy@infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113000932.1589073-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 11D0C40002
X-Stat-Signature: d8ba3sfmyoyfohps6n4te894hr5wq11t
X-Rspam-User: 
X-HE-Tag: 1763037074-403097
X-HE-Meta: U2FsdGVkX1/kTphw2G5+BeoTtS0C5FTJX8r+NkJwoWQbGHeAmnEVK0AWy/tgh/F7k5/qlMj9bv5xOUZvxCLxb03uWu/izmu2Q9OVhFBqIDWlmhom314WmCSncNdri06ydgt/gwLTq5BpcUcGbhuPMIj1W/8kj8EZtFuaumhyJrfSYm+CSOVeblDl5fqFPg3ngHmkEIY7bmR5/cpyzgjdmuH6hMa+BeE5yxVDGpMteRwr1zRfKP51BVFwZO0Gd0fK4jvSvxBUo+eI0IunLIXU2RQuasaYQAsER/aMgFF/LgTf2zMjnWi3bFp+j41CNl5pU2h2gjHGLw0IAGhjL6yDzjm/b714072JAJfYHsFC4uQCmtGQDN65f/5QGCTmR2mgYV25eEVxLSDzTajPbJZ8v3Oa+1RWsxLHYDe+f96dkC5LXqh4kM7s/VmVzR3JmYUTADcPvlQOVSBSojYcLlY78BSRV3jojOCaXVM36YONFmwG/eDtL9Sn94+bYr3BSiqG+d+eiGU9vunuI6XYBz49eYC9YzcI4rwE0o0JZ6bSgOZUeFLsbWQ+ThNhGdcg7JVJeJLWaTChALvKOhUUbuuwEajVD4J0OWjoopVuxhr5HnkVrWeuRGLwzL8yPPnm8LW0RFAyxJgFzHszX5xz/3CxT9vPqVtQDXTijkiT7+jDZi8aFaGZLXv5+SXKFOcBJtfnIj5mjkPq+283/b/aEhJPzscXBKr/jUiUQ/m56x4LwXjsxbnGKkBLeGV5Xq5rzqB1U8OCYixd3ZKyMHrv4QtQObmG3kYqbyumcyiCSasP5bKwfOmXAOXZPFRfd1D8DwIlTEn8T4HbF+JQPcCtBITBLva2PECMKZPiTCL9XvytMSewSLUpr+LFI+z+aepDIDG6Bsp3d1nNzWGYHFHW7qHXX7WmXBL3rhu/L3MOj6+C2606QBzOcdhNQ0/8BhlBDRX1kOgPh32jTAHE/K7owkP
 DjQQ8bcz
 SK8iI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 01:09, Matthew Wilcox (Oracle) wrote:
> In order to separate slabs from folios, we need to convert from any page
> in a slab to the slab directly without going through a page to folio
> conversion first.
> 
> Up to this point, page_slab() has followed the example of other memdesc
> converters (page_folio(), page_ptdesc() etc) and just cast the pointer
> to the requested type, regardless of whether the pointer is actually a
> pointer to the correct type or not.
> 
> That changes with this commit; we check that the page actually belongs
> to a slab and return NULL if it does not.  Other memdesc converters will
> adopt this convention in future.
> 
> kfence was the only user of page_slab(), so adjust it to the new way
> of working.  It will need to be touched again when we separate slab
> from page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: kasan-dev@googlegroups.com
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

