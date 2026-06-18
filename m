Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CA3CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99656B0099; Thu, 18 Jun 2026 04:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70906B009B; Thu, 18 Jun 2026 04:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAECE6B009D; Thu, 18 Jun 2026 04:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A452D6B0099
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:19:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C903A0661
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:04:19 +0000 (UTC)
X-FDA: 84892295838.13.8EC8BAA
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2DB201C000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:04:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=DlOMLRml;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf20.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 78.40.148.171 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781769857;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Um0iholy7NtKIoOFnNm3rYwqCi6fDk16hVrlqiwRuKY=;
	b=Ya+f+UBRzhcfifKCQtySNlOi0zwyE7PPBcwBVaQiBSDRGalulfOevK+zEWPQXoZn5RHSN4
	C9p0NpeyOTe38ZeS5ag7BFvjzvssBKJlFAXJw9OU84JqPK1ZAtTWb8pN8w4OVe7QAEj3uR
	kCQqCWrQ8My4XxCd3NKnD2AIHt7I4mg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=DlOMLRml;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf20.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 78.40.148.171 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781769857;
	b=IjCxP3yCbj1fPOoYpao9HPi2J3tHDsB40D3cV3LvQytzFQxihMD8EMOcrBN37LEksANXyf
	alG/rJe+u75MxjUbbq7PAEdrZ4CSBSEzWr0H0thuG2+cuRFcxt0cGl/n+CO876fmtQJE0O
	thD1pbLzPPzf1xL1XWNZSL7X7i/hsRc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To; bh=Um0iholy7NtKIoOFnNm3rYwqCi6fDk16hVrlqiwRuKY=; b=DlOMLRmlGPJSv6iK
	jnYvyi9xgI4NIR5Byil9ZOGQpBsNIsgrl3AZdKL5XZCcRClC58gneGt5EQCZyIfA9iointgpDu/1B
	S+53xeEXmR1KOwv2H3YH7JgSDFbas1EFdDS0iNy2zUFBQYAVvKG9ihCx0AjU0xQ4fvN86eJheXUwj
	kR/JzA0LM/tuh3EDSuKYpzW8sZa1FLIPV4LIk5691qhST3Br4/Aq005Ru3vGwxyqfTkstGRuAvxct
	j/B7HbGlePImSwgfFvdPc4y7KC02fL33FDgVbQACsCOsOQAT9QMwvyvdEJy4Rl6yP0UosHMkt+uzx
	S0QbMvC1yaWZv+EYuA==;
Received: from ipa12.colo.codethink.co.uk ([78.40.148.178] helo=webmail.codethink.co.uk)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wa7jM-00Ex0d-82; Thu, 18 Jun 2026 09:04:08 +0100
MIME-Version: 1.0
Date: Thu, 18 Jun 2026 09:04:08 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: include <linux/vmstat.h> for
 vm_numa_stat_key
In-Reply-To: <B35448B6-4958-4FF0-8AB6-5464C2D6C50F@nvidia.com>
References: <20260617132726.1086576-1-ben.dooks@codethink.co.uk>
 <B35448B6-4958-4FF0-8AB6-5464C2D6C50F@nvidia.com>
Message-ID: <5e6b7e7ce7f9e2da70a73055eeec4157@codethink.co.uk>
X-Sender: ben.dooks@codethink.co.uk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DB201C000D
X-Stat-Signature: qoi3ob4cy9detxnbfdydzdfqesxsh81t
X-HE-Tag: 1781769857-482270
X-HE-Meta: U2FsdGVkX1/KIY9HCx5EjEBvchEXUaH4JyvNL4lgORTgGtcwWcqXoOo5FBgK2+CGnzXQ4x2jPlTZMZ9ESUxpv66ygCZOd0PPqeAJfZ9+T1cnD3SBorXUywKr7L5tMICJhyx3ZaRNB1zCJcBhwIb4DHXQwx2hQtWrdeWg5uHK0IihRxUe2m8tn2j/EgFxjAqanjRnFpyQNV3Cvfjd6346AgycKdHRfFsjIuzrT0Gt7yXRIuYPlNWLeDdUAHi74wREd70nu9cudc0UUT50tno4/pAlwDnAqCashpUcN0M8RN683nVek27fi4UysmSSc7Vc5f2BCWhsZbs8QM00GyvC1pxZZfljS0TT2gO5ENvwv1TpWpViWk+X564KlisBzDjMdv6Q9+NZHimItATE4P2VAYqggmdLMq0MoBg429Ozy/8E96VM7zNzCdJsU9hYV6bRJv32+gUYAjohzuKYt+f17ieQ/My+B37rQLMN+Xe5eMiIgkX/ECgH6tIAZkA1nDzsQ8XTrJgxPlXwica/pGkUr6VWEcoxyG03DM3pRZvP1oI1lwv6u6pI1bM+saMXHnJ4fxUDhc+3QtTiMocu6CHhGb4FaWaK0vTjnLaurwqq6ZtDenvhBYj9F7NrcZpSqyRpX5ozHy5WCY54AuL+FfO65YVJMf/jBk9HFNj93stAsynh+pW6enrcrS6oRYUy9y08ATwT3h0rhrRnmVbHxNIj5JSECUoMIPqeXWP5l0I7VNx0NQy38OJWdo9Y6rS6gN1wXoCks8nw+VMQ5OkH9egxUlpGMX+tnMmfutN4WH+1AymqMKgwYcw8nFr0PUA4imRC1YjyaghvZix69xmg70umCMSD7yy5s4mZOJ2jEcPv2x0hxtzKtKoTxdubHFY7BeyKpGUACycTMxSoyxAfgyJZRx2/q2w7YX8ZndIaxAvKD5G1uoyL0yzBjs+y4zrZHcvT8ha5rKz7i4vQgsQO0HE
 V/s0qoVz
 iLr0TZC2Hp93zFdtJKesFs6TZ0hItEY7ehsNtFdnBBVK87iBcnmUe7asZFFtfraSDWyEcC2tq9tI3yYRJCAiEVo391YLZ+Hur01Z+vbtGEn9QEaUKm7wSMSwsLbrO3oWc4bwOG9x0uvORTx35B20AaRh6R8LMnytzHJVQEZlCRh8i+23NZAjp+P3yIm/jNnCVMD3wKy0lBGcy9w8U/2ZDovo1CYrBBrkyjpymt8NC0SDUB1Fu3MF7O1BtlUvn4VapG73OCKmJYlw+CNQ3fhw4vUWe/HM7ZEwUHtnTUK/Ztb6hMkAaYpd/EadERm5pJImvycgdMPdK1VL5hnzukfPfzYrdeDNqK9VJdZuTk/EQNfXoWRwYIYwftdrAb6DA5uH4HxchxKRlid1dCnXPabhCIqCyMGwpfbdMA78HMfk2INhDCizT6ogdlqr+qvDplJRnNqnHAqkEbHtWgI4GW87tU4e/56wyLAhsjW30
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026-06-17 16:47, Zi Yan wrote:
> On 17 Jun 2026, at 9:27, Ben Dooks wrote:
> 
>> The vm_numa_stat_key is declared in <linux/vmstat.h> but this is
>> currently not included in mm/page_alloc.c so include it to fix
>> the following sparse warning:
>> 
>> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not 
>> declared. Should it be static?
>> 
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>  mm/page_alloc.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
> vmstat.h is already included at line 37[1].
> 
> I wonder why sparse complains and why adding a duplicated one below 
> fixes
> it.

I'll check, maybe the order is an issue here?

> [1] https://elixir.bootlin.com/linux/v7.1/source/mm/page_alloc.c#L37
> 
> Best Regards,
> Yan, Zi

