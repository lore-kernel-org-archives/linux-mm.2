Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A3FC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6B46B008A; Wed,  9 Sep 2026 11:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467D06B0096; Wed,  9 Sep 2026 11:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357B56B0098; Wed,  9 Sep 2026 11:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10B446B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:17:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A7D012024B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:17:14 +0000 (UTC)
X-FDA: 85194577188.30.FB550D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D38B9C0008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:17:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJwf8pIJ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMpwt5jk08Xm5DwGlNwjV3jDkm0c7VN2w5E4BNJFyJg=;
	b=emxXdO4ajkKS8hfxfux9r1tMnmjrIvECUmIXvLAKWY9Ou+oQh24ZENtgGOlZocqxujtkTy
	TkgOTbPE3WO/HeMXsKqTVVf6qx+ipH0V0uwUEFT8sOlAJiRJxjLLIZGRqQcJS33Eji/kSU
	S7c857732sPExnZ6C8a5Kw0nrmlo9eQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJwf8pIJ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788967032;
	b=CWNRAOQpI9bq7vtyb5zXZqoTumohL2LjGMWgVEB1RhayCKF1D91K+omrX02bR1U2x2vv1m
	HF2N53M6HA5CgvlO59SCfXP8GGlicBZmjgzo8JiEmEm6p6h2n8QecadJSBuuzYqzE+7N8W
	PdJ3ubrqvdzljnG2NwqY5eiCGtQohQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34297601F1;
	Wed,  9 Sep 2026 15:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB451F00A3A;
	Wed,  9 Sep 2026 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788967031;
	bh=yMpwt5jk08Xm5DwGlNwjV3jDkm0c7VN2w5E4BNJFyJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bJwf8pIJ4fb1VkYkGkn9jh7csMatHoWRsh0+x4jVPH0Xe9SW2SoX9ayXbWiM1jjfx
	 ZXeT4klcknZmthc19OrMRbF2BfbAWxXM84R4e6zrJEKFF+G9OyaX/X7nRQ9SECaAaG
	 FaPkfhLbpb2f941jVa2RWNEaQYZzOfX5ba5d+eSI+Li12enPOuHkTPVHeCgm4drkhC
	 oDYHixZdVpzaIHG1i3Ylq0eWuQmM2mt2KAKLOp2EkANf4qRa54hMQ9jVE/RRti3DKz
	 p7qho55XczRF5YGnwYYsa1XCBpuCil2sblZsIrRL3PVE2i6xWNeHm13J/mJhc32VOO
	 QlJrT1YNvbzkw==
Message-ID: <91cf8129-d705-4ebd-b420-129bab7ed261@kernel.org>
Date: Wed, 9 Sep 2026 17:17:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: trylock the mmap lock in the unstable tree
 walk
To: xu.xin16@zte.com.cn, xialonglong2025@163.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, xialonglong@kylinos.cn
References: <20260909110228828hKTCgUeuZkOujOBaVtUcL@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260909110228828hKTCgUeuZkOujOBaVtUcL@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D38B9C0008
X-Stat-Signature: ifwghhcc5htfqzx7wprcr4rbigqjntxt
X-Rspam-User: 
X-HE-Tag: 1788967032-862365
X-HE-Meta: U2FsdGVkX190MSrc9Ejtl1A90HMqIk2kGYgbymTqkEoY3W9i0YJTSTUzFJGVnC+RwQlvSGEcY/D0y7XJWSKOEYZ/6Wi+J2iqOWUKv7+jy8uQxdCn8fDe/zvBpWUcuJ252eydn1w4T61nPiyTGKtKhQs9rf+dWtXMvpYADMFawfXVktzXAIbi0Ht0805ZFZtDfMrng0CggT9CONXp+NShCw+f+hCMwSfGgKEql3yQyYb1z8Ki79OdI1qFEhkkJBNM0FFFYM4y9+S5qigyXTLL4IPJRKkHb2wwAfT3/nEXB/yDy+NmiPUACM+Z+QuRnWue6EaLWw/CVNf2Ts9pyZQSPypodpN+24xJ19eoo4aZ1TzWM0L/XWme+sdSLCn2A5PzE0OoKKdxB4W9kvok1ZCiaFrb59wQwhjS4fnkPxafJQUow9lDN0BMjkKmVykN/l7bnOXIzcO9M8NVtqAjcLoOVEEUzP9uSsQkY6xOUbe7/X2TtuqVm0t/HsTGtGGyWfQqMQ+3D2wjmVSf3qZ81t1akJDrVZ/VZJsEV8xpvwlawQB8YGr6qRv8SCPXfc2tUXjDLVCChpLzX6bbwxrqO6PGEHdAUlgGd/bcJHSvxs1zUN/76gT7bXrl/uiBKZ5oh7LxGFu4aYFDAFPY/3b22bAqnLWZ6OsBKP60eUd0gIbyiIWh8HVOdgNjQCd/6WB0a3ytaCnkam9Pvd4SJNf0May6jl5tAPcVeHWTnt2LyVhQLiFcF0zOUM/XUKrWAQGqAT/y3pr7f4+yZc4+CM5Bx22+5v9f7MvHClMdIRHo3zb77R4e4sI/ed6I5cPooY9RNUZ0RIFvMFelq99qOJn0hiO1vMgzzFJNMr9tIyE3f11MkbpwfMGoAuH8EU2+UPYDyfvvwaAG6LevkaNkXI7g8uYinGTl2F0CElzoaJxJ79+kYiFjpsUUmE/KZcXkh2/v4WRkQcpZgdGXYkyx3Kdnait
 de0NOpUH
 GK2oDmI4Ig5oXs7UORvCa1utJtE3q863CTmjWaA8H6v/4Y1hjzzJC/cd1FZxIdcZ/J4fLH+k07rLlA9+w8O8NC0TsSz8JVz0Bl3RqjEK8Ak83oVGYYXAaC5FPB+lzXeCX3vRrBU1jKd9uJPeLFrpVsrl21Dw7wT0MqNvQ0ogRSgfvgCvzOGjaabylp82oy0K3bzNnIViMcM7JIC7th3EBIGtZrdlW0OGztlulPL5Ge7DBZwrBse/m1VBRzTvotkW5F1WK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> index 49d48d1e0998..3cfb09a926ff 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -820,7 +820,14 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
>>  	struct folio_walk fw;
>>  	struct folio *folio;
>>  
>> -	mmap_read_lock(mm);
>> +	/*
>> +	 * We trylock because we don't want ksmd to wait for an mm that is
>> +	 * busy changing its memory layout: we prefer to skip this page and
>> +	 * let the next full scan retry it, like the folio trylock in
>> +	 * try_to_merge_one_page().
>> +	 */
>> +	if (!mmap_read_trylock(mm))
>> +		return NULL;
>>  	vma = find_mergeable_vma(mm, addr);
>>  	if (!vma)
>>  		goto out;
>> -- 
>> 2.43.0
> Sorry, NACK

Agreed. Likely the answer is to switch to per-vma locks here. All we do is a
folio_walk_start() to look up a page, that's not too crazy :)

-- 
Cheers,

David

