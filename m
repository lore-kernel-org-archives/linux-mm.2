Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1531CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203416B03AB; Mon,  1 Jun 2026 09:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA966B03AD; Mon,  1 Jun 2026 09:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA036B03AE; Mon,  1 Jun 2026 09:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F03696B03AB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:49:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81596A06DB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:49:09 +0000 (UTC)
X-FDA: 84831475218.24.16C5D0C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BFE591C0017
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:49:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0sfzR16;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780321747; a=rsa-sha256;
	cv=none;
	b=mP1sg+UDv6k7tdoDPUKffsPzAv8DRw31YI35zFmbpZzbMAsJlln/2rV5LyQjF+7/Ahg/EZ
	MIIPh5z7o0WN+KuyLk7nOfbIp+uzQUux5fd+u2sX7+BtQlZvGHswKcLiPHITn+l5/+/6Az
	ASWEzhrjpZB9MZ1kET1vbbCHMNaUSj8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0sfzR16;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780321747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8MuTbax1OpDSMhFOx3LhMmqnI78KaFW068v5tAv4+o=;
	b=bHCBhtHvq+hbQ1nhPoub9yDyFuzFdH8hMCn83q1OMJxs8+aMxedyr65nqXrrBT2MtnGX2W
	T7E/0pt5CBROep/qPZNrC1LZmTmEgVdDWbErQ0yPHTDu229XNqfI3c/ecVzDjebQZavTqo
	bHNerjE8Z5QvVk9jUd+O5ZdYdc/w1BI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AD8D6014C;
	Mon,  1 Jun 2026 13:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A96A1F00893;
	Mon,  1 Jun 2026 13:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780321746;
	bh=J8MuTbax1OpDSMhFOx3LhMmqnI78KaFW068v5tAv4+o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o0sfzR162SZSavIyVSshFEI2HSXfICi4mMh2AHcrpeNw/Apq93kpeNNncZwQhxUl3
	 5JtWWblZ9adw1HL9epdagwm+PrTY+dMU3zxEB6zLIv+YZKfhWF6J2ehaoBd0aJl8xo
	 2ygjGPjWmggQ6AujluI5hNW9kN/T1ovneN/sMhwqE4jNtTRd7f+IOIct/fUSDu8MES
	 fjNNc8chRjPuIao7ywI6mlawKV9rUUh/FdoxenP4t8V9ldxht/o8MfgcxF0sIponRB
	 xMowtEWLSp6B4J8kHHpb9L6h7/b/dH+ET/FCeX04Mua62D3ZyZXf6xuhUwyvI7ufli
	 hX7v2DjHvKmAw==
Message-ID: <929875a2-9e94-4dbc-9c98-b342ccc3f4e2@kernel.org>
Date: Mon, 1 Jun 2026 15:49:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
To: Dave Hansen <dave.hansen@intel.com>,
 Xueyuan chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 yang@os.amperecomputing.com, jannh@google.com
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
 <20260527035607.14919-2-xueyuan.chen21@gmail.com>
 <4e0696ee-895c-486d-aacc-71146f0e9047@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4e0696ee-895c-486d-aacc-71146f0e9047@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BFE591C0017
X-Stat-Signature: ko69mq11tmofp3qtuqhmtn1ne9dy39k1
X-HE-Tag: 1780321747-102650
X-HE-Meta: U2FsdGVkX19nVPazbp8VBUd14io4IlfYd19s5KuInAgPYwjBFJ5FqbaGo9F8kjcuDWk0QoY5N7+XSP7gGO3QKTdqbrzMI0hZcYK5qEKJP0b0E1o4vBA0JznBB12YUAlbjuOjLQ6vOzppBT4T5i1HW+ms+funAM8C0wnKRDo3Fsfgr6YFnBSh8JHZ/JHo5N3orodGfI2nhTX2kFkB8OxY5anmARUFa0hqtjFRU8uRDol+iNwQ7I0ZPEXLxWAZR63YerKAzMqcNwkv3kqrzld6f540/dylaDq+5znbcYHeIgN2dTQk9iZib4aRG+85X3sQMgEpaV1+qg5MUl6WAOfghfBZLgczUbOkDwXNxk45dDXtTmNh5ELDPpgEpk607BFUKzzX9+GTOoxy2tH3GOJilzC9cSYxgF40hqL0EPX5FbF+nm8aSrRdw2dxddvtFxdSpiV5/FQ0KZszkB9pugh9wzjOE9qsXvFG71D6dBVFtqgKqvLY1MvdKkP8qCwcrbtKEgoLtpnUe89EYm5mqaT0UB3vNRFKPg6VKeJdfTcZW5rOL34AYa2fTJDBYGEDxFcZeWPZH2xX62WUCz4i5lBVg3C8DjM7fPclhxrci7SzjxlywR9siYKPMZyeg8gbtHNsjZ6XeMxIQV2egITTBNWkayfF1qIgR4rU4wYQIXYMdYcvYGUVsGX2V7Enw//tlTc/j9l6VcovUOCPnxH5gExnIes2T4sw9h/XgQJ7Uuz12/FkHyU1iYvbka0vYSkb5th5HX1hef1peF2nzmRBoI0Btrfo40jspigo2ilRM8O/vuGz7Vd0sCY2Kjph2pI8Zdiy1r5rNr69pFKTwSPx1IZiX2SVwgLbm404oKtussVK+aaoBGj+Xo2NBXEa4MI73+p9Y+jeVLyfqD8EDXdpymHj8gIQW5eFFyiS6Lu/rJ/RuoUxRQC9f5ZlA8EoTxEuZNrm21RgfwpUlW1EJz62q4o
 17OSAleT
 DsZdeO/+xvXmSnLGUOD2o1Z23M6Bsp8olVcUdeV7qlhILdT8Z1CNioxvumJ+HkJW2OxAI/xB0Wa0ucne/rGmYoyY+lqukxlztJABExtjcWk+5BMJqOLdtAAr+ickpKaouVUjWN9IgJTCgkNcs2ZjncEbuS7jboxscqpBEeYaBkxZsHmDIWFFihz9m2npBhOlK56rvVyxvPVBN9Rb8L9tvFpjqsQT8sSa2KczjgsUGsCgsD1omTLFqBTqbbOonGc/giOUsP4TYs8yVuBaKqgA1gWHoD1lPwkw6kuwQ5aphnmKEyWa7CpG+WhPezuU1Zw5S/QMsmHnEkmhs0XM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 17:55, Dave Hansen wrote:
> On 5/26/26 20:56, Xueyuan chen wrote:> +#ifdef
> CONFIG_READONLY_HUGE_ZERO_FOLIO
>> +bool __init arch_make_huge_zero_folio_readonly(struct folio *folio);
>> +#endif
> 
> All of the #ifdeffery needs to die, IMNHO.
> 
> This function is also a bad idea. There is nothing "huge zero" specific
> about it. It takes any old folio and tries to make it read only.
> 
> Just make it:
> 
> 	bool __init arch_make_folio_readonly(struct folio *folio)
> 

I'm not sure whether we want a folio-based interface, though.

This will likely be the only folio (that will actually have a "struct folio" in
the future) compound page we'll ever mark read-only ... whereby I'd guess we'd
want other non-folio pages to be read-only in the future (encryption keys etc,
maybe?).

So I'd instead use a page-range based interface or sth like that.

-- 
Cheers,

David

