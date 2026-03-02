Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 450E9EA4E1D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB4E6B0089; Mon,  2 Mar 2026 10:11:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962696B008A; Mon,  2 Mar 2026 10:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881A26B0092; Mon,  2 Mar 2026 10:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71F256B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:11:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1633556E57
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:11:46 +0000 (UTC)
X-FDA: 84501462612.14.DF607C0
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0FF5180011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:11:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oT5+jyWw;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772464304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXXw9BNPUOHdywM1sGGDpV4CuKnSXirRfOqdKTWATAU=;
	b=NWe/V2KjYDIop4AR4ab0rQ7XDPYzo1yBytQ6Dpy3xRuebZ3fLqIFtEQ9Qv/BoGUhGXVHjk
	OF/FPFJtAeO77qLzz7aBcNGz60OSlAcTbm7tAsWntdlVlSDIrxgY7Lsr8ePr74plylNLzD
	sfCsLTrcdtmC9qYvmTEry6vm5pihu44=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oT5+jyWw;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772464304; a=rsa-sha256;
	cv=none;
	b=Ox9AFyUr1cOG5UGmXU2NO5r7w46RVEYkQhY7Grz2iOWeu3aOsiA3YosPdKBiHYrCJ6h3wY
	JHvdvJ0DpiImEf6D2kyZxLfbHD1u1zc3NTbWgt1w7cDc+nAVxKg66oIA0+J1Z8ZUO3LQz6
	qwKeV7jV9FOONEi9N+RrqOTNNYsVEbU=
Message-ID: <6a568d3c-daf3-46ba-a3ce-0a0deca824c2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772464301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jXXw9BNPUOHdywM1sGGDpV4CuKnSXirRfOqdKTWATAU=;
	b=oT5+jyWwG/YxILKJmwFoom9NuVkMPFACb21bQYP02+BuJNutRR82NYY4ImmIDBhgFQ/5gR
	sfpjsJtrYJFEB8GJg9Fx1BbwjJqXGIgL+gQPoU7+5lJI75HtJA2X/KGCd0sgCBDh2FnPzG
	hZGcZvbRoFHZQzg6m6SI1Dz7B6yg2fE=
Date: Mon, 2 Mar 2026 23:11:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: fix a folio_split() race condition with
 folio_try_get()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Bas van Dijk <bas@dfinity.org>, Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260228010614.2536430-1-ziy@nvidia.com>
 <d9e30bef-621f-444a-a1b0-510c50927d9b@linux.dev>
 <64fa6a73-8952-4ee1-b7c3-8b0ebef3ea78@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <64fa6a73-8952-4ee1-b7c3-8b0ebef3ea78@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B0FF5180011
X-Rspamd-Server: rspam07
X-Stat-Signature: a1i1kqkgyruincprffanpxsjiwo898pa
X-Rspam-User: 
X-HE-Tag: 1772464303-708003
X-HE-Meta: U2FsdGVkX1/tSYJ/X6J+0Ve9V3lpK9tT/cxsOIMkaTlUg0Wo9NvCAIwshILLpbTHIITw/t6fylnKedWXi5yYwmZsnjapeI1r/OASVOtuNmgmYjLPqvClsGhxhZOwgpM1sRCA1LtOFUi2jSAu11BW/iJlB1IUdN4tz8HMqUIEfVQ+dWiqXT994nYqICLcmfNNYosCVwgxN3jymbXqyGWzyOEa8TFtakhjioZ5z1LgXY5F6UljCy0LGyiwX6Ea6iPj8anmA6y0ogc9ZD9vvXT5Eg5Pn2x17q055iOiwp9Ekjs19rwFO6bnV8m6vxbMitBxUr4KKUwubRf5WKhrgcpwnMoHxrMFj0IF1fNVG6jX6RthALmvb5D5i1xv3jSirRlJGn5Kpg3uvs/Ig2kJFnXN4/BLnPRznpNEAeghPfGtWjM0B6az99h+2nnDVTf10I3UcfcQdL6m6Ke88eTW5U8iHoAVoHTZMo9Qt1SyZJ3zAa2PMMasTT/fd5e78rIPbEV1u6Y+pTIMH5nBhLaXSS/OT4GF8VIk0Vcgur8SM7MSU1OPLKUO+cqE7JkYUU9b1lmaoHNxXYQuLGqhao4ibOb6WvQ45Ilu2Quq771BNbT0rFGBfzv+VySybMtIET9eS9WtRFqYONP+VFES80KehPGkiDX7mQPC35zevH3rSv6LXRodNZMnbYsuogTvkNvngaphqYg2E7+VkgNZ+mARbAIQ2wAlciKTEUo8d6f1kcw2RlC0XOcVOZpIQX6OQ5/jcxNXR9Xgnsk+l/eqTDFO1PawyXWwnzGOsndOqMt8Tz5Dvbw81D2jDuQluTB+RnlAeKI0pcReBlXdPYNsAVPEHUSkXN/A+Lh2pSiVqQ7Jl50hbpGw0AryX8JY+YaX3kikD8t6tC7lF3SJkgoIdEqz5fJub5/vitMyD3ZCkSwz+5JlWPWxcycj3tCGyDxPSVlfBrXUctXR54KbNvUL19WX8eh
 UWIobPKa
 4s8hpT8hBg/z5Ytte7n3+zIcY50DkAu/I4UcDJ8t91FBOrzSTjvxLpFTfVhNLnEeePyo71f6kYrR+v3HS7L+VYtdjW1BmvNLQg1uQO9MCykG1phEmz5Zrdr596QDaizbdzpVlOCc1EmPZg6SzNMb27SRLS0w+v2QhVWK/5DveiwC+GPVHiSae8uMMUB+pi1RZZ6Nxo9N2NvQgqMIvNVhHBVtmzRvbUuRH0k3E2pENBPTE+l99Y9DJ4m1qlrC9SWugKGRUTR9kgOUnJ7ci63A25dNR6+YQYVC4kFMSmK/mYzeRCuqLkPVhZLhM6pTMr7TSjZ0jaxR28njucLuJL2lrnG6+RUjTlpHSyrpHoh5OV3hIlej984oAUaA7o7zFgckTL2EAUTC1j44u8Gnd1h/dKXdAXm+XPnvIxrw7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/2 22:28, David Hildenbrand (Arm) wrote:
> On 2/28/26 04:10, Lance Yang wrote:
>>
>>
>> On 2026/2/28 09:06, Zi Yan wrote:
>>> During a pagecache folio split, the values in the related xarray
>>> should not
>>> be changed from the original folio at xarray split time until all
>>> after-split folios are well formed and stored in the xarray. Current use
>>> of xas_try_split() in __split_unmapped_folio() lets some after-split
>>> folios
>>> show up at wrong indices in the xarray. When these misplaced after-split
>>> folios are unfrozen, before correct folios are stored via
>>> __xa_store(), and
>>> grabbed by folio_try_get(), they are returned to userspace at wrong file
>>> indices, causing data corruption.
>>>
>>> Fix it by using the original folio in xas_try_split() calls, so that
>>> folio_try_get() can get the right after-split folios after the original
>>> folio is unfrozen.
>>>
>>> Uniform split, split_huge_page*(), is not affected, since it uses
>>> xas_split_alloc() and xas_split() only once and stores the original folio
>>> in the xarray.
>>>
>>> Fixes below points to the commit introduces the code, but
>>> folio_split() is
>>> used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
>>> truncate operation").
>>>
>>> Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used)
>>> functions for folio_split()")
>>> Reported-by: Bas van Dijk <bas@dfinity.org>
>>> Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-
>>> sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>
>> Thanks for the fix!
>>
>> I also made a C reproducer and tested this patch - the corruption
>> disappeared.
> 
> Should we link that reproducer somehow from the patch description?

Yes, the original reproducer provided by Bas is available here[1].

Regarding the C reproducer, Zi plans to add it to selftests in a
follow-up patch (as we discussed off-list).

[1] https://github.com/dfinity/thp-madv-remove-test

Cheers,
Lance

