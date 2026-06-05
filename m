Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6B6CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B0C6B0088; Fri,  5 Jun 2026 05:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C2D6B008A; Fri,  5 Jun 2026 05:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AAF6B008C; Fri,  5 Jun 2026 05:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42BF96B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:43:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3BE440426
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:43:04 +0000 (UTC)
X-FDA: 84845370288.20.C3BCAD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E501580011
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:43:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZicdtrQ;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780652583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xmuk+W0szZm0MB0FxCzfc/CYaV9E+9Y95Wl8QIOpAHw=;
	b=z6oecJlCRASJl575+MjYt+fSeov9WYQ7pxMJkuerwAiTNbmAnvIXusydwcvlu1VaNNss/0
	sTq6rzGb+8eaz12ep4ZsLMaQ//ZaLV0juhtsjmTPWquvowTeMfAdiq+H8AR2Tfpg3feKKB
	j5fyIO/POIsOOfDd6ARQW7tKwfTL/SU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZicdtrQ;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780652583;
	b=os5DKlP4sVEosIC3HtRhDqWlTWnxpE0OSxj7mMdYbphZUhWehUwpAFCNCQNmkHmBpRDLHE
	gt4fmvZWC4PVM71EPck07bv8sDxUcU0oykO/aHGj4jr8lUSU/bDWP/Lr1HsX4g4+hU38EQ
	DQHe23FYy2ssKw0LWs2CS42AYdTxksY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 214F942D8E;
	Fri,  5 Jun 2026 09:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B1B1F00898;
	Fri,  5 Jun 2026 09:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780652582;
	bh=Xmuk+W0szZm0MB0FxCzfc/CYaV9E+9Y95Wl8QIOpAHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eZicdtrQBBfWG4DWXT4vTG5dcBNw0tjzyWV9I/2tt1uzMOpEjWhnSrZm4xCtVE97y
	 AWdYo7+2iUAOEm6QWZxwpKgS5ppcScK2sduqe4ijbU9uwqno7G2GEoajz5KOqQG1mJ
	 gTxvGaYrSBygb5dtdKKKaVP39g3l6RFnxis4U30f4REAcThlNQ7Rmm8tUr/JT7qRVE
	 /EyvpJyUNkTxJLnWSBFwkZIzW/heyErWtqUtzquUTPI+KnNpOeZH5gQKNgfZZsOvmg
	 j/buJ4KgSl7ZADooiUgVFopGFcyXP1cw/7EjDKfUyUOnZ3RG3zgxzRJFWHr1ZKhWJU
	 uDMIfxBjiALnA==
Message-ID: <f1a742be-80cb-4256-b1f9-e50a0f83cb15@kernel.org>
Date: Fri, 5 Jun 2026 11:42:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com,
 Lance Yang <lance.yang@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
 <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
 <aiKXrovzrNN-gExm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiKXrovzrNN-gExm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E501580011
X-Stat-Signature: rm4uz4r51u87dhydu5ficoriaf48e779
X-Rspam-User: 
X-HE-Tag: 1780652582-11722
X-HE-Meta: U2FsdGVkX19wl9AyUIEPAEM7hWZpEjFQYjwNdlBd8TQMw8Tmq+YRADqyY23ryqRxoKE0StMzppCpLUTarKaiVbJt7tAY33DmhpeJBTNWLoJ3haIS2Lo4CG0KR3mA/Iu202FA6irq+PqumtzR59gwqaHO60I7K7NcFYGt/OsAzUyVbKcPhgHcZosgvETfZP6O+i0ph9u/bQyzGd0+C06Kf+fzyyzmZgXc8zP2JVMKBifbJszRt5+BOQDCoBVJHrLPHgAR40WXGerqmfo5WsqHh38JPeOAIOpLldbFYAwcK7jJrJ5QGoqIEJnzXDHarcGFIVKco5mejtIJ2066MU8dbPwm9uEAHtxgNn6sbwN0Mxir5JADOHZSbLd1en2Sy9hBz2kC9NcJTzJGlTeMBMMAR/t1+ZCdibvifTKrrR5E2IGbe1J65vhHQisA22EYML1g7dCCEVAGNPtzpTombuhA6S4nbXALnWAPqvNVPpY3dGuTRk2RneTmtqhAOZjYVLucWlmJ55wGnh9YjHrg32NQtL6q18MTkB0UXazdNLaES6M+ADD8efxgAmLBY6oQtvisryFRtyI5EEIcfOjs8VBORy3HMZlMNU1CEDDJr6zbQkR/lImxlEeshPvFcOWaZCBD+aXeFl6cbo/us8FTKAB4l1BdMlvO2Ky02TYy+u4a3FGlPI+1RJFPbwzeKeC9Tci3BXpGvIRONau7cX6gaiGXeC58SF/6GAc3Fi1Ua8OnUlTf+xSehRiz1ng7fCN8U9QfJg9G/XoySh6b1LtskoZlXFnc82+LVnn1hmKAHvNH2rpycfRyoYpR60aN515p0odESr6QGWQ11tjKDuPGahlPaMl60farevrtrMJF//6Bn+qEPG7MylDwvolvu6C6Ty/ohaEw5wbsQjmZPMmpooOahgLVcch3Hu9hOddnbXxRPT5nmzd8U9yszVwoc3SVhnydEvf3i7j+8OjsBgZEOgj
 /brNcbu7
 bJyBIrxx2LyhR+keUI17jNxnqkhPM/P4eUh/DHTQ1zI1Wo5E8UC23Gfl9SP4lG5bMVbHv/knISQal7JjQ1XFHiCjxgF2mNTUSVZajVOl16srIyOyu0y6MXEqHKy/WtxIwWlM8NHj6kzuPIrYCgaCM9stmhJC/i8kK7pgwIUlGHsJs+0TRIci2XRCA7olwIvE/kx/3Bhiy6AzMvvVNlq86nl9zGTj+Wpet1QEWHdHvefDmDR0VS1OKsdhXYROrgf8l07dJsc5q0VyiIMWo9rFjEtva714M6cMgTitwYwERkOS6WwpxdZhHUbQXAxr2Yu0SK0kXBEHNg1J8rnsCzy1Jry3H+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 11:35, Breno Leitao wrote:
> On Wed, Jun 03, 2026 at 10:33:04AM +0800, Miaohe Lin wrote:
>> On 2026/6/2 17:41, David Hildenbrand (Arm) wrote:
>>>
>>> Races are fine. We might miss some pages, but that can happen on races either way.
>>>
>>>
>>> I'd just do something like
>>>
>>> if (PageReserved(page))
>>> 	return true;
>>>
>>> head = compound_head(page);
>>
>> If @head is split just after compound_head. And then @head is freed into buddy and re-allocated as slab
>> page while @page is still in the buddy. We would panic on this scene as @head is PageSlab. But we were
>> supposed to successfully handle @page. Or am I miss something?
> 
> You're right that it is racy, but I think it is an acceptable race here.
> 

I mean, any such races can currently already happen one way or the other?

Really, the only way to not get races is to tryget the (compound)page,
revalidate that the page is still part of the compound page.

I'm not sure if that's really a good idea.

But my memory is a bit vague in which scenarios we already hold a page reference
here to prevent any concurrent freeing?

-- 
Cheers,

David

