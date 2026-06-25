Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A17DCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEF76B0088; Thu, 25 Jun 2026 09:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F7E6B008A; Thu, 25 Jun 2026 09:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1856D6B0092; Thu, 25 Jun 2026 09:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7A2A6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:50:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 614BFC0114
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:50:07 +0000 (UTC)
X-FDA: 84918568854.22.68F5592
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 975A4C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:50:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1pdQuWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782395405;
	b=8Dr51bFpotsLfLJZpfR0ORXSYeCHIGZHGcPXMtF3Y7PoQxrn16PhJ2mjYhhQvrtubQva6/
	/EiYoKy2WbsBmBQaZ1qm1cIizZaojCgpfnVgYfHs/HgxZFHDSeBctl1tEFQdYTiCN+wNr4
	EXnr5DwaYna8+OzxmI5I1N1eRt+MaNA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782395405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZEvrq1rrrMd4FVzsWw5pXlFBvqw6BPmoVEk+RfJXuY=;
	b=6ZtJJDr32TnxoHr/BBAfeV9yFBwaYEL0WDoW6Bt+fjthx9qJ8iOtb3BTnHAZTgRVAi8Zk+
	eT3ohHFF1b0l+vZaRaijc+nVocn1YpJihPbLKMp1yY0JqbzdeM/OyG6Ir0B5ulNOWDD/Hr
	6Nu7rNwx6E4VFyuxud6BHE6vD0VTLQA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1pdQuWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 238CE60018;
	Thu, 25 Jun 2026 13:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686451F000E9;
	Thu, 25 Jun 2026 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782395404;
	bh=CZEvrq1rrrMd4FVzsWw5pXlFBvqw6BPmoVEk+RfJXuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O1pdQuWOc7ragH8O4oJsHJgAAwPc1CK/aQG79m/s7SIWeEf5VeD+Zp0RU9fWwwRO/
	 fWpScblCB5cS57o3qQ96pw3tx25S6M08e2m65GuiNUtPo77+T7gAgqglREXrMAp3bc
	 SdB40CQ7eUEoxkFjTxYkUzBr1YYxU8mlJ2mh/HOp3Wx0f6OLPtfhLRq1bYGIQ5yP5+
	 YgACRUFJXmeYg5VvXdF7yt5mGF4v4VJQXox2lVd7fh7pK1dNKWG5doDZXJvVY8zicD
	 75FKzMl+UvlQ08wpJGTkHbznlgwM3hrihi6yMNQU+DxDmy4u+GNyEDwg6Nd3uWWexi
	 15ekJj0H41kqw==
Message-ID: <c66f4bec-0933-401b-bf2f-a1b2e256023f@kernel.org>
Date: Thu, 25 Jun 2026 15:49:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
To: Lorenzo Stoakes <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lance.yang@linux.dev
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <aj0vjdBN-oNMI2yI@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aj0vjdBN-oNMI2yI@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 975A4C0009
X-Stat-Signature: c65jrbuko587hrcg4c1zhaj7ah3tcy5e
X-HE-Tag: 1782395405-149061
X-HE-Meta: U2FsdGVkX1/698uDA16Nh5OKlRTb9yB9N3Rb5D4nQjoxPNI2PZ9Gbr6JNriDmhDtibPvDvUcn+iH4Ay41xqkJ3vd0TcE/Eah493QQNQ3Ae/c2E2uCvbMaqOdu81K5LnS0FTy3jMZhKNssFmUeJlyxozr92M/513QAHOygM5KhGbLy00BRZhzEfBNLDI0ulQVEon1U2nDu5Hqx+x7U2BFci52KnmKlVTJizWNpeFvUaa/TX7yjg8IIXg5g2iW1KrgF45y5KJjeSWMDBrVx1SehR00MCY84Yf2yT1DUMw8kAwdsrppQBmLzU3BUpNQo8DQoK+YK7FUJU8sdO0r4i7azE3pDEZPVqyzlq0f04lFsjRsLwjzwRwQ5CEYLZbFy71zLrGhDmGCWTgmuOX+1R3O4u6M5fYXgT9sueBt3ref/Y9TZj1IxS7ykCLN59RTSm4E/ENbkykKWwXDnRgfse369u2su24jW6SaJtU0/gr+yHOiUTcY3Fmh0lWVMOHrosqnrjbRWu3fbJkcccyctv9D+Rkk8cGa8lEaBl6HJF935ri/pyeDG4RsF/jE/OARXVl3RhNqBzZyg99cn7uxxZULOqm6+7lcsEuklFIxMfA3xYd+MdFoZmMmmwA0kMwRTzUIBL2fFDwl8eSrmC6VOTK5gC2t+zT9jbJXSER8yiOHSjvSINLk1df1ZF4DWAEDQNVegzpOT+0uwWZ8MtTzxbTouPY0RN3RTgnjVdaIFzKmMl3ECa6WVVO154+X2JW3egpd5qpoe7Mav02OSf0J4feGu/E0+1x+uxoB4QpZxfYCccUC3bGc2oKj7Mbi1R+AukumUU3o1ol3XtAaG4oTKN5VwqYicdSJdaKWsV3O23Cr9EGbu76X5JnegQJCC5zh9eYS9xM/lUb5nllfrHrUdRzRHC4kQRb/nHhh5a6OM9y2v4EZn01MjGXilT4xkHuygUP0o/xDz8yq1ldthKlBRbM
 87Med+3o
 7YBYX8gA/hlif0ndOM0uTmi/Fi1wYCJuIh8OoaHsQ+Pvy8XfFppXBUvksmpaokBaYkPnZ9m4Xe8DU3tDgzNLYSkO8KIHtbwpmCvUL4XnD6clayXzGIqDzrzKZpM0owTKAalDUIKHJPWAH/Yv0qrKcuA3cgKjD1F+iexZK1V+gWkrR1F22uFnZyoXUCjEWgpmM00YwJBaZ2RP9VqVuB4yoF23KxkzVO2oq5y5DUIEOyIjix3fEzqsAMkRseLD2AAPx6TTWCLpvGEaSrvhO/loNNbpAId9MQaGPDX/msXpa5HHOhlgPcJumKQ+y1cHlwkWuAiDFOl1UzAnO7+83sT4ViwLuS47AoB/9heClVPrdQzJzGUvBPr4RMrkzLfymgyxDEXic
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 15:45, Lorenzo Stoakes wrote:
> On Wed, Jun 24, 2026 at 08:23:59AM +0000, Wei Yang wrote:
>> The kernel test robot reported a build failure on the parisc architecture
>> when expanding HPAGE_PMD_NR in check_pmd().
> 
> Let me first say that I absolutely hate that we continue to support museum
> piece architectures to the point that we have to make changes in core code
> to accommodate them.

I wonder why we shouldn't be able to trigger that on other archs with
!CONFIG_TRANSPARENT_HUGEPAGE ?

I think the code just relies on pmd_trans_huge() == false, and consequently
check_pmd will get compiled out completely.

Now, the report was against Wei's new patch.

There is *nothing* to be fixed for existing code.


Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")

is just wrong?

-- 
Cheers,

David

