Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 023B1D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 06:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CFA6B0088; Mon, 22 Dec 2025 01:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAB46B0089; Mon, 22 Dec 2025 01:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD5B6B008A; Mon, 22 Dec 2025 01:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E45B6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:03:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E389660C63
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:03:48 +0000 (UTC)
X-FDA: 84246065736.09.188C09E
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 19BBE140007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:03:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z3Q+8HPc;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766383427; a=rsa-sha256;
	cv=none;
	b=YWIYLePmiqYXj/3JaOj/gKODxHq8f3myImp7pQoX6hWNQcYyiDhFkZcBv4DYVq+bpmlMM5
	HRMcu8V/mH559jiM184hKKAxU9cFtxRfEztl4cPbuZtUj0/wsSJn6FZPxHWn84v73eENds
	HZHQw++0/8irvHluvs7WA8oKhDqM2oo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z3Q+8HPc;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766383427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdbF9OBo6i2zx9TZjagXwoBgfeB1DZlPblGdya54H4Q=;
	b=kUxmjV2xcSZbN2YzNvoFFYrunnK8APRPfiboLRwZCN7LKADWMao/8vgUK8ikaIuWk6r0Pn
	IOLfThle1Y94ArSWeyNJZElqUw2WmdF0ljPHEiDFiwnVHJHarqGBdSKe/U78fWAVtjmnhf
	ST2Fjms6jQ7CNCu7rbZzPQyn5mfp3do=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766383425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdbF9OBo6i2zx9TZjagXwoBgfeB1DZlPblGdya54H4Q=;
	b=Z3Q+8HPcxJK1YcFgpkyBcRtK+6lyq/q3U+WEyqNwoZcE0oH9m9xx3fLpyG+cxISRpUOQli
	9rp3Az5AergCmoG4irGDKUw2UWCmzGpDz8sRIPSqfCdt4TSYbdmfhUXNUet4GVz6fW0cs3
	1jICIuujI7tUAMl5/8h/Yq37mKoqO4U=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 12/14] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key
 static key
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-13-kas@kernel.org>
Date: Mon, 22 Dec 2025 14:03:01 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F44CAEAF-B834-44D0-9BD6-26AFA7FA75F6@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-13-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 19BBE140007
X-Rspamd-Server: rspam04
X-Stat-Signature: 89mc9ytuaiey5a6ti4ikaw17k1kghf86
X-HE-Tag: 1766383426-429960
X-HE-Meta: U2FsdGVkX18z64kMDKhxJLN/lR+K9cks6aFTy/QVifZSEjQan0VFZOPTHihfY9YGr88i14OfZBsa5avDlIF3msbwyz5frzBH4gwx9+desgl38QOC4DHvaj0H/IQ7v6vCu7dij0SSHi7M2WTxhS6X7+1NHAHpPt2MzoHBvSB8FxYRcV0xiXoBylv1HuUqldjp+nwqhRzv9gcX+YyiYnp5ns+dxPNegmNFFAjhnPrr3EOOJaLJF5QWRzkwPhxi9R4rsoyS0V+X+I/depKkMco2wLtPkvyYn3Ee1NiE3i3oLTik8Z8YpKTfcE8FYvDwvL2gIKdZwDZ36udXnOYG8IugblI/WA6Ra4wtSudskNjkemwMTP2Qwoav9qC9IIS8iAutY2wjMSX1SA4+Q8Wf+0kf/qEdNArthmRweo/0CCXiN/KM7T00rUALoBQ6syfJSUpjXIv4h47fefcXyyrZp72vhYxy39tjpnCrm2hBQ/ocvEo+8ppkd7DW/yc4Snnsm9Ws0RZnL21Rw5A/J8DFQeJxe8OnyxcCbaYR3pl4aLE8PqICc6ce+WZdYSOfM51jdpOygZYgWsVLZH5NH2ml6V1Mg+2X0daoHbVDq0ghLYRf+pTc8xWF7Fi4p4UWCGNgwwX28bG9qRppoc9ri8WGyc+y3r4D06Bf8XZkm1ZwUFcViXElLGQBbiUlfQfylVFoiP5x/QqXloodmDPK2F417eC/etZ0FdC/z8cLj34eiiUHFud0JHgDK/mTQsaueRhVQZxJJk36wqEuBrqJxy39m8ZXehuJAVX1tv9V9sC59KZPow52/IqimVefkwjEFLyn1wRgXDX0eQ0sBVbV5Mns57dDzLSmMNI2dyVV4UKvrlDBpGUdmyUhF31M4W8Ow7fDAe2APqmI4l0Wmbceko0CMexoXNVA7FkP/pWHhbcgPvkIWyajase3BZXS1rDnpTF8K5zABTujMsgfCgRGWTLS4jS
 gACSAmgB
 PLzoar+6YjbQONNia6b+7f1g5qTE7VHiSge59+noYpafQeNFb+isfZPGlJZPWnOvlJJqqNYQoL5apXmaIHParAZjqT+ubHPd03WFaLWSluw7/BZuKTe1/hyQw//O80mqGkzNhETGoeZtqz6V2QZqA99GuvM6xZSEBcAi2BKf7/8qd6J7ogh1/sZLjVFYxAFiLI6LjS08fvU4vO7OZNaMryEz7U2MYDNpwkxGbZyWsw7DHjxSLvLEgXFu4EK8nRKzlu9D7O1qH5iCPrDyNfFoGoWGv2HvwekWVqVY0mUYyzHCv+PH8iuvq1iiQKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> The hugetlb_optimize_vmemmap_key static key was used to guard fake head
> detection in compound_head() and related functions. It allowed skipping
> the fake head checks entirely when HVO was not in use.
> 
> With fake heads eliminated and the detection code removed, the static
> key serves no purpose. Remove its definition and all increment/decrement
> calls.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


