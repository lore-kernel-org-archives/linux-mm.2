Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA023CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522CE6B000A; Mon, 17 Nov 2025 09:25:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA496B000D; Mon, 17 Nov 2025 09:25:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437066B000E; Mon, 17 Nov 2025 09:25:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 321476B000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:25:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5703B61ED
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:25:12 +0000 (UTC)
X-FDA: 84120321264.18.A9C15E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 27E4C1C0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:25:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8Isrkiz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763389511; a=rsa-sha256;
	cv=none;
	b=ktTQIegI17OJ7+Zi0cZ/mAGFV7y3TmxEYQBvCmgF24smoCJ+cjWf9J0ksngaq1norsrcR+
	NysTMOjFEQ6YQimLzchLdI41pmJmaCMOGyLBIRzikF+0SJKsXGssdC41mLNGFvC7Ql23Yq
	wjPimhaMtzEjlfVYKeePlYKhJKoVnMs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8Isrkiz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763389511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqZUNzfB0WGXqkA564hs30AY01SSI6DyWRRW6+oOOPg=;
	b=RaJidiZdtcSaQpogK2uECz4a0G51Q1arE64Yy5Hepg23ln/t6fnqSnRi0AAt+wj2dIz7Ev
	HXqnuNz0CxqPGKt8JZCLBNdbJ+c0q4SEOHLrrSkYH3fDU2Iughl8LmvQl+5acu+FWAxL67
	9Ot8Jg9TvYP1CFno8MSWMYQsVaFWn3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4939F41AE8;
	Mon, 17 Nov 2025 14:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A24C116B1;
	Mon, 17 Nov 2025 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763389510;
	bh=1oClKF3XIx42GRgp2slE9G5qGbMG/nS/e7CJmqp78LY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c8IsrkizjOj8dpvUcAu/mIW04zCRZ9ysG1beerNSeOC3U43y/0YVjnrzcKeCJyqLF
	 D8BcRk8nfX8zxvbwcPQcW5vmpEipGc82w3h5+TCYJ6zpf4vD4Hd8JI7ZxKaINtwF4U
	 lolyfp8taUpC7R9/JTdWyqN86jIIv2UU0w1+8JKqiHj6a+q4ueYP0D3BwwWZjgYZPV
	 Lcj5NE7gRP1Ap23LmbzEg9m54agh4w3OpxYmXiBsP85lfSvOW5UyvDHsEjyTpisPrR
	 btEaHdbXsKMlz49dhxv6tabHHCbZl81+zK+GC5fzcGNXz9Q6GRwtJBYkwQRMxC0f2U
	 b+47gQs1Jp93Q==
Message-ID: <069adbf6-181f-420f-b2b1-0ca22894d904@kernel.org>
Date: Mon, 17 Nov 2025 15:25:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 27E4C1C0007
X-Stat-Signature: z6p4qqsesaauhms6ya9gi4355wgxozog
X-Rspam-User: 
X-HE-Tag: 1763389510-898158
X-HE-Meta: U2FsdGVkX192x4iSbZzUFovbWqoSHWnmv880iOIUJbs+qGsVJAVi5hbftnSv/9ZmCO01rJXbJe+1KnSMyBe2kZ/EQBxqC5vJ17ggd30jGdLikluE05cGN1Iu0LA9lW7WbwiBcI0uo5l66Mm/gmLwNmB2RHwFHcKAynwvxDsF9PbCpIDT5S/IZQGyMJTohunnG/JBuQR9xN3nxEeq0JWz1GygmbOfABHOoy6rt8FZ86ZSED4xc2sASLPEFrRz/HM8VP3gG86UGz7/ID6dcgrlkZbFYlmxEXBQqDjC//QGUgb0r2eMbhabU7sew1RGjDh7HL5fP66YbOp+10CtAA5G8B6ED5TmnCHtljOcBaHr4Q2V9kdZBRMwPZlsMEcz/JkB2M1sR8pI3zruFn+7rPgTvRxDehVh8enUWMgvds7uDnTiO5Xb65hPnMktVYpDcE0krY8LB8dGVqWZiW+AOz5oCo0NPxw4ipkHZSQ4CppJBZXEfA6jqSosKp5Ii35TJj/aPGiG8YkNDTDwZ4vRVabLMBwJwzqSEBk+RcZBfl7GbWmnDKXGOdtqVg05LmUlsPlFJngdIWE0g6VkEPREVbXF+0nuSCMiMIBkt8vA7cf8ikq2PgWu9oOk39H+cDQCkzoADhTTTGP9WxISQBMJm6bfLuFg045+QelEDABDaXBOp54p0xHO0AcuYSRdreI3sjhCPeRr7j/G9fjIThIJGQLQaee1J4XyHM7uM5Ib+QvAs1QNF9BnDC7K+NBJ7NsvEc/RFL+w/ofTCRxD0ULBT4BVW95QFCX7rk8rzPqIBW+wmu9hrM76XZqymDJmvGdCPoCw88XvrkIs0EXtON0ZE2B31kGvyzCLYZ6TWx/KfcYvhBl8MrGA//BKdg12fdIiw5C6vYUz+8dEfxHmujqkg2pIVuP8xyRg88cDpP2Alt/1AeviUXae0Z/dLCvGzo+TMNNNUrEMUHumVJHp+h/uQ5E
 0kxV5FGm
 fGTvK7Lup7ZU3NflXqe5DHZKTl9ZMEX9Z+WI7KO3EfQovnQPAQyfmPg/KqQvoEaSMdBKS6a1Q1pmodZFqyiC9uY6+dDBPcs5miLDuk9ojRIWXVm0y95DXSfmVLWl8Y97K1j7pEMn/W5QdDvd+2lkvo2e2fMQXLkEsw0QEdslp8JeUES6dMxJ5oN1BinfZxcWZ2USh2vS1jTVaxCN8mwfSZGG4cjiYbwZ3xf9qO+NooBqVVpzC6C/ZtwpMU80ZefF9JXzFEMUrsRU/uG63PJoQy5BFxs5xNRkXW3T12/f/x1mt6tucE7eH3SytpkZG75sb8zaV9Z5pUfyTQUSxk4OG+9HofKERgP1hYSUU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 18:53, Lorenzo Stoakes wrote:
> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
> 
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> 
> This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
> merge, so one VMA may possess the flag and another not, and whichever
> happens to be the target VMA will be the one upon which the merge is
> performed which may or may not have VM_SOFTDIRTY set.
> 
> Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> which solves this issue.
> 
> Additionally update VMA userland tests to propagate changes.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Looks reasonable to me. I thought that we had that behavior in the past 
... but I also remember scenarios where we would have imprecise 
soft-dirty handling. So I assume this was semi-broken for a while 
(soft-broken :) )

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

