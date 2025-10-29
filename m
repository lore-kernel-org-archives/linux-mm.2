Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17733CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658528E00FE; Wed, 29 Oct 2025 16:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608A18E00B2; Wed, 29 Oct 2025 16:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8648E00FE; Wed, 29 Oct 2025 16:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA248E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:59:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDB06140933
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:59:15 +0000 (UTC)
X-FDA: 84052367070.16.67B6354
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id AA9FD18000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:59:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=udYUdv8L;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761771554; a=rsa-sha256;
	cv=none;
	b=Mc1tHPTWlC8UBjxR5ZJwXL0uSx0MKibdvi7Nyg82jdgPJCxx3hswz4ZhuQ3ou+RondGc0O
	BaGZ8V4N7JOfFOlnZO5zqJgEg4fbldRe4t5lW7uzd/qFFBgvLyukya2pWBfFPKO6bZwo9M
	VPzOBcgojAAPNYLW5us4iUm+5AAi63A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=udYUdv8L;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761771554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uj47k14sXLy1VSzlZ3Wr6I7tnhfoNk7VxiAKYjOMT1s=;
	b=WSDj3mOemcP4wr0v0rwLvMJwQWb5hCmOgEhzFE9L1NkSIHLj3Nd46hRCMYaymUuptH3mB8
	g61LThs2XjMhkbvMOP903ja1d+YsI43pDJIS/Xg7OCHsU3OBJ55gn5zsNbk9n1EqLu1ihc
	OnpwKxP5gs9NCT9NpUIlrnoeI1sKs0w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=uj47k14sXLy1VSzlZ3Wr6I7tnhfoNk7VxiAKYjOMT1s=; b=udYUdv8LXQ3PYBTk7DjvAbHa+X
	ZeIiCUSmUBXpdlQEQYY/94VnHRsU+5L8Ss+2AxNRErCzDdpBaC5uzTHQ1NbXwhUhrZxJzdoQI8k/q
	WCjJd9d53rjX2AWu6B6DP7V7FHkhzuEs09ypSEqTKcSaEYkbke3sdrzOpp59N8f9iM8scBH2CJPJV
	QD2dHPJQ/gLb8U71Ec1ndRX/iRdoXmbZPv27jxZq0bK+BxZkXlAJeCj4GqsHtmIAisgOmtkIAU1V9
	dH7x+LkTwlu1h/2MCGtSB3K7RNJVmylyznJ2Pi7fTxpsXBmMuZP1Nq+f0tO001YVBvin15Kn85iho
	A23xQVaA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEDGB-00000002sii-0pWK;
	Wed, 29 Oct 2025 20:59:11 +0000
Message-ID: <4b7e1be3-6351-421f-b483-3fa433cd994f@infradead.org>
Date: Wed, 29 Oct 2025 13:59:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: change type of state in struct memory_block
To: Israel Batista <linux@israelbatista.dev.br>, david@redhat.com,
 lorenzo.stoakes@oracle.com, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: osandov@osandov.com, linux-debuggers@vger.kernel.org
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-3-linux@israelbatista.dev.br>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251029195617.2210700-3-linux@israelbatista.dev.br>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: p9qugtp8efcd4o7h6w1kx7tcc9g8kpok
X-Rspamd-Queue-Id: AA9FD18000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761771553-117830
X-HE-Meta: U2FsdGVkX19gqwuK09hmpcVfuM2bAhcUYaYPoKCr8odoR74DA9QlKHQ/BswgmdLfIXzVieZC+tW9yNXMMibB2ES/0s/pSepB1c23QbEcAZckmV0MEBfdOyZMxlMUgtPpnZhNDGC/+sGdYg9mY2DS3qle2aKPGbxKK/ZlF0v8d8EFLILGej5ggA8h3k/lwj0koNKXWK0P/NZh93KWgC/y+XMZ6jkKzl8Ry3sjHFaqT7yXswwvmQ1YDhcBq+6nKPhPNw62CBeRB860lR0l3DzDBU+mG9e1r/vhfecz4FnGtxVzQxiLkxHG+XkAwyei7zXM6PUXpLaBj2wCKWrQRH4VZE7GPIGz5X9KdBnXn4179asuBebOE27eHbLBXvkyXVZXfJGGtYTfDSkKUo/pg/4zipBec3qAP2AYU6A0xMPPcD4XT5fWqSpCzbYrDSrzGP5CHE0UN0zc9i0QzQGhrF97dVvAopq8wZTjycNrFJPzp6x49rJ31HTc4KQZ7M1htf7Bha1hEYdz25wvZMp/KyLBv/6q/gRozozT+ertFX6sTUe/DK+XnVl0xcKMIXSZFC0IeKhLZ0EwTXvhsQ+pfqgKoVMspQB6XzsV1UroE79JLWsXymEdkrQCly2fkeOMf7k8vX22gmXzVbRpLT+FlAfbPVZpeM+r1QYfYkwh5CLRl8mMlC3D9ItUvgmbGM126fS1+iEDjUYv8DlMmNeKBcXAl44dcz9Pd1yGW4ef46giV/7Ll89uRz/EDCTLO38D2w3fvwufC3m1/l93JxYRvlO1V498O3BOo01pHq+mMLOqFml9GLT6vengW7gl5qmLwh8O+2eoav2XL549/aq4tz9ZXzpQ79CrNLgP0Xo0mzk6G5BlD0d4GY/2ZhDcyj4EUen2UR+AKCtSd9sGw2pU7y5Xk4zgV27HZesqsUnPCHjLhvXf1TRqWVB+Krk0jlGOHpYJg5HXlBt3oV5Z6bGzuhV
 4VDUGU7S
 DDhPV/zBiDZlqVMOfkRgHDl652xjqKFvEYgfc7GqVkcV6CSFllLiXyhczs2rgXinMe+7d0UTw53W6W0LbIkF7zYVcjpKC08A1Sbt/8MI7qkZ5nj+UrtlyvsH/VpEJVkQpkyixSrw5MlX0PjQGBlUNU3M8PRNuExCwOeqEkL46Pcn+LZ3nrFmucj8+rJ4LjRJOuT+s6Jt6p/MaiWP4rUhxnD1PMP9kCxu98ashgDCFg+Qt72HqNC6p/RPa+tS2CB7jQOmvDEpfE5cE9zgoQ265Eje6TbOUC9UiAk1tl3XCYTXpNHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/29/25 12:56 PM, Israel Batista wrote:
> The state of a memory block should be restricted to values specified
> in the documentation of the memory hotplug API. However, since the
> state field in the memory_block struct was defined as an unsigned
> long, this restriction was not enforced at compile time.
> 
> With the introduction of the enum memory_block_state, it is now possible
> to incorporate the desired semantics in the field declaration and
> enforce these restrictions at compile time.
> 
> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> ---
>  drivers/base/memory.c  | 2 +-
>  include/linux/memory.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 6d84a02cfa5d..3d17dd774947 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -198,7 +198,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
>  		break;
>  	default:
>  		WARN_ON(1);
> -		return sysfs_emit(buf, "ERROR-UNKNOWN-%ld\n", mem->state);
> +		return sysfs_emit(buf, "ERROR-UNKNOWN-%d\n", mem->state);
>  	}
>  
>  	return sysfs_emit(buf, "%s\n", output);
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index f4e358477c6a..36d733283329 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -78,7 +78,7 @@ enum memory_block_state {
>  
>  struct memory_block {
>  	unsigned long start_section_nr;
> -	unsigned long state;		/* serialized by the dev->lock */
> +	enum memory_block_state state; /* serialized by the dev->lock */

Use a tab after the ';' please, instead of a space, to align the comments.

>  	int online_type;		/* for passing data to online routine */
>  	int nid;			/* NID for this memory block */
>  	/*

-- 
~Randy


