Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 783851099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45396B0121; Fri, 20 Mar 2026 15:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D106B0124; Fri, 20 Mar 2026 15:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D334A6B0125; Fri, 20 Mar 2026 15:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1A6F6B0121
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:01:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62AFC140278
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:01:32 +0000 (UTC)
X-FDA: 84567360024.10.ABFCC5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 81D168001A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:01:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+DYdCns;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gu5o4M1YDtvNJx8jTmeB7AIiifH0HAd5D7fAgpSus4w=;
	b=ouC7uaDMNl+ggOQz1iURVcyxYDmVLMsByQlAdm0a9Gx4YWyxVaeAmvaRklOY5C77S81xQB
	TF13EI1vrTj3sbwi3tDWuMTEDjrv+1STQbxi1Ihg/hOK1zHzqgFjhwjx8AjBns+4UQPaba
	duuVew8AzxJjR2Mw81PpRjTbpz1W4Y8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+DYdCns;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033290; a=rsa-sha256;
	cv=none;
	b=tyvjc3RUFU2nefMVdZzcXylBOpnwXMZ2mE9Q4FzpHyrkZWTajYKSpbXHhdNqHbM82wnbH9
	RSnB813YFFoaQrns84P320xculS44g4A0vO09ODTA0hv+wCsqysOO0+bA/8em5MY/LvY1r
	g7Bdu+8Z7qpM5+erYVw8IxZG7HXm5fA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A69EA42A9D;
	Fri, 20 Mar 2026 19:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94740C4CEF7;
	Fri, 20 Mar 2026 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033289;
	bh=Go0/8EQwhplhACJQrhYExZ9tpVDOwumpsDmVzEC9Lxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W+DYdCnspbMI6H/1F9SVoHHsasL/renrO0hS+rA7xIZbWn1Wbs4ycVFVIpxta3Nr9
	 M1AL/Ta6JRGRfSwRfMY3DS2vulBvoWkmU/UftzF1MaVAEY07AWz+BORSdWW9Olr3HF
	 2cCTdNZZ2JfryNpc6CmrthwoPffOJK1jTMQmJQOdLwlcgRQyxc56CpRtwua/eEMKez
	 XhuaMdUnu5rrHYbNmX+a6LDM1PV2nlZ2Gfrt2z1QPFEFDzuh/lJZMRV4HFebodP+0P
	 wlsNxo+arGn4N50pp4wCtF6gSwQpibboNj9IyZw6q+mA+e2z+nD1JvNEZSMrEzeMKJ
	 Et6XPW5jdKJQA==
Message-ID: <6701dcd7-7e02-43eb-b929-87fe3fd9ab00@kernel.org>
Date: Fri, 20 Mar 2026 20:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/14] mm: prepare to move subsection_map_init() to
 mm/sparse-vmemmap.c
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-11-david@kernel.org> <abpmbj8mCZjt6NxB@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abpmbj8mCZjt6NxB@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81D168001A
X-Stat-Signature: jscesggjbn51oexxptx9kj51gx5t5f7b
X-Rspam-User: 
X-HE-Tag: 1774033290-565252
X-HE-Meta: U2FsdGVkX1/zFM0j7mcvHZutHPZRL+5WgiDHHR+ad1w4Ba7AJiE8flXTLRcXSF5C9fJzt63gaFA3G2e+IywYw4G+BARgu3AnNX9UYwtZPAyrdPS0szkUMO78uHgfxxLmuRHfnYYeN1pErTi+VKvYeV7BPnQFcYuaThXua6h3kDy1Wu2u6PX9FL2kAFkf3gtUUEb7dwEa6rO/7iQNlaoORl+JA0POKfHnNXaSteT+DtgBujTJbPKT0fH6ivn/qBlN6fSxPpzRDpB/tXJaYPtU9tVgVQjo4k/OQrolc7xJtDBmOp4jbKzZrnwpdVgIjmiSXprvwW4Lgaq7XQkzmr5CN2ro8BRoP1j3BqM12tLeWCLfkyhY9cXa+ZOFy6eqItZV5XFSukkFtd+t0anlaLuoNs8flzBtxOqZQspJjbUoClNHiRM9dmRVK66cS33PpyWLS/XWFj9eqPnvuy4ROmyW363BvyEdwEsWTcbMKzVL9WG6g7gkjjbqgc6Gj2iMZtfhOwsPiHAqwh+XvY+9g4Wv5t+Cgj6WbS5P8la06BwrWN8IvPrFiGHZvdJG59nsvxayYagAjClHvOdsd/1Pza6P+laDWlZEa9llcnYo6aL7Vi+xjWPUHiFF/e+yCy1SmP+Btg1L1RIQAxOqWblCCSeDSZrMUtKGcZ1j3pQQZMCQzJwxDvCLZochz4G3ZeyPsnvZQvoASCN8/eRWNZfN3CS9SCkf523bxZ+u5VvclOG4sf2CVkrISLilw3g+hrUSOd08X+94r4w3DZ8QE9vWnbH/whObtVP6P5XPuR3f3qT6I5V6wo++d4A/nYi0qP68bc3S1MHO2f0PldVW7SKCPqRm3gdt1vLlyuYU0OuFUhYN4PGS+692TcqWlrceEDC9Bu2ahhTHtd67cS4lhZk3zGyyL9c2qBcoqdJMi1k0+YjN5OsYuGKeKORo4ONS+TJv9oyaoffo/yvQy0voEpLzIgA
 +qHo/Hua
 gfkXsT3BPlvk8a+ZPQaxpAbw9toWpadyszgj/e7+siPmTjIublOiDFU3fyNMSzJy3MNlFNLZqux12Kyxv7UeoRoN/rzQtycXPjnwx+vFXhkGyfhFR+SGWEibEvoR0iFYvlQnuy/wiNNewveQYEZ18k8eIniZUdRMI4XsJRJNZ0BCL7HsDZLYoEDWaYgw35ASURGpUhi52VWWnX2uFyrj3f15SRq7T+Ga7FtA0AumQBXR+raYpj9IaggKMAxXzMDjO5C7rGipd4mV4XARe2kguQYbbk3YkeqCIwIvtI8Uhod/uKIUwJjSfw+uIcGFyPPeB5PY5Q4oLq+xZS9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 09:46, Mike Rapoport wrote:
> On Tue, Mar 17, 2026 at 05:56:48PM +0100, David Hildenbrand (Arm) wrote:
>> We want to move subsection_map_init() to mm/sparse-vmemmap.c.
>>
>> To prepare for getting rid of subsection_map_init() in mm/sparse.c
>> completely, use a static inline function for !CONFIG_SPARSEMEM_VMEMMAP.
>>
>> While at it, move the declaration to internal.h and rename it to
>> "sparse_init_subsection_map()".
> 
> Do we really need to rename it?

Given that I am placing it next to sparse_init(), yes I want to rename it.

> 
> Maybe add a "global renaming patch on top, like
> 
> s/clear_subsection_map/subsection_map_clear/
> s/fill_subsection_map/subsection_map_fill/

Well, these are all internal helpers in mm/sparse.c, not exposed to
other MM bits. :)

> 
> etc
>  
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

-- 
Cheers,

David

