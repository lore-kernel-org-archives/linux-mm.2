Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5DEC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0926B0092; Tue, 11 Aug 2026 03:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9046B0093; Tue, 11 Aug 2026 03:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF076B0095; Tue, 11 Aug 2026 03:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 342AC6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:16:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5A6480357
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:16:41 +0000 (UTC)
X-FDA: 85088131002.20.EF11329
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EA05E20005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:16:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOudoCQ2;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786432599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAjfoJTLbtwp9U0uBxqfOmUbhvvtSTzTjtAFNvksBlg=;
	b=KAjgLz94wzeAMEQ1uGHZoYo0BEhcdXP2VlOzaPZiaiMCVVXPGc15sbxGOpSlfRhJjRHHXp
	Bh++R6MbQx7Ib3Ewj6/3cq6KdUXMCO9eF+aoLTDC8cdNaxCv51mZ/J8JieuQg4G6peY3y2
	3aPsHXEtVi2eaxn9zP9TRGj0cMYkq3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786432599;
	b=PRfL6Mkt0T92QEV8NR2ZBuVlZnUuyfvhvQ7n7N2zAOaUPf8+PHEKVYgob+9VkZFdQsS0ml
	l484V/vv26wzcQXjnANCm2YegOg9nPmyDe/u0AFVf+hp3jqulkNEPHn9b08b6LOuwOX8XH
	hdQqTo/DY3emozqbQjo0mmFalm3vDww=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOudoCQ2;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D1FF600AD;
	Tue, 11 Aug 2026 07:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACE91F000E9;
	Tue, 11 Aug 2026 07:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786432598;
	bh=tAjfoJTLbtwp9U0uBxqfOmUbhvvtSTzTjtAFNvksBlg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LOudoCQ2yzrFsR20h1+2GJdInQI2/pGgwKvPBAnjZYSVVjppVdsEx82SbYwi2n0Cz
	 zWMCljlm2Fc5l4bKyMuF3+VzWEn7hI+QgsMUYqpD70WaqbZr84birjXKCbEv9BoEy8
	 1wZgFi07AJyt3qAMBxsbsyl9XewLIrT+rnXHWKn0qjxXWfQoVzhN5XIP9RDY3m7s67
	 TDJoWuh2YxWbwt7AldAX1T2qesbORBlFRrN5Z9lOuzNUJ6x7lIkprTno9FDnRBYiKU
	 sx8V2QZ5zWjOCgYNfgQwbaq0oAuUxeeSe6H4LiS/IQxC1WdWAK20acG/ptX36dqAp/
	 nI4ZZdHXEDcSQ==
Message-ID: <af459a71-8362-4f90-ad25-599a1e4a7224@kernel.org>
Date: Tue, 11 Aug 2026 09:16:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: fix stray newline in auto-generated CMA area name
To: Ivy Lopez <skunkolee@gmail.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260811003441.63725-1-skunkolee@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811003441.63725-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA05E20005
X-Rspam-User: 
X-Stat-Signature: 6gbypzw5y683fj3c4y5uc4choe1dtkem
X-HE-Tag: 1786432599-974409
X-HE-Meta: U2FsdGVkX18pGzHpuFyEwEpXSQKa2m1ASosa6VXwwL3OAMAY7F+RzFN4FZbPEMujfviz1+eCYQPCe3ieJmPzr3300hqyOYn3AJGWRLZT1zM3IEvNg2yPQkuJc/HTS7JQ2oG9OTtI9nYP/+2j5ZjZXIiqR2/888V/vHnB+VdfA5DEkOCL/vBHutgvBrGWmssGJo1C0JLqcGrtsgOfJ+MP/fqtFkjbzQRAU9uZtlznrdt8FMj9X6KJ4B7yD8ty9teMZ5DwSpM8MCy4WeS4yMT7gWP5zDDbj+MBIUy4UgeN9D/py5zWQ0hile2pFdU57NmzUhll1qWNCBW7dbzjHyC6XWmspw7ijXWtKZm4RUGE79YClyNFAZKeemVht9dZECmNUsdEPB7t93xoR7h3kqAvZSTqoE+hDiQm9nog6+430WxLEuzMKonlEHxIO0gIuOtHXCvaaTfUeI7VPu44Hts6ZnVLBYJUSaMG2GK0EQsN0eEeOjqDSvTxk6vm+Pl2lTz83I6zER2K2WBOaG7SvpuZeW2IlGKa2sXQUNW4XG2mVoTgHR5NaHkFbtjlZrY1jZfkOtipVM084NWzN2KSwn/6vH/rPSjfWQC4S/S2nRKQtGe+J6TmRA9Vhua1r3PJCZvhWbGwYkrEY3d8mfmIkJlUUjZzzj5aIUN7Hg45ZH9rH5MyfBNICbzir0F0bpEY3EmKa6SNJepMhSd8Bdhm/4OiXmduPY2O1OCukoq8A2XzeUHCqIdkF3D559FLMEMI/VU+lqEkY/NZRatfcoExxswjXPUqDdQFiyhpWkTQTvsFlpMdnDIaBnZ8P0GOseQR0+1KoVqu4CtTvSBZicp2E7dFA4k90939HDaL3pWj+TezcL+QvgU5YtVZoHQi3w4G5HoCvlS2rBmu+g4XwI0lbcp1rrxsSb/o9EDs3QhjdTv5jy2NCZtjAUtXdCF1zialgt3q349EmSjywp3/GrTESGx
 T65X1hCB
 yjBgYD7i6zhaloBMOllpRYPtZy1P3WICBmXN2qQJv8F3lGOycBFaI3z+fespZ67Hulcae7m1PoDmhzPOu4jzx+49NDsGwiZqEYv2qt511OG+BaOTog49HJSGZe7BdsC9HPY/THc8uy4/d21Ne/xfUufTUhUjYIs+E15ObvU6iJLa6n70YXRKefghaheYgDrIrFt85DmLnRjDkyHdldy65PFa29t3+fhafMh0tA4eAXwBooW7OkaiaEohUICDZ6Skru5SfYOce79ziAxIn34dw9ex37xD0cGcaNvjF9RS7hv2YpP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 02:34, Ivy Lopez wrote:
> When no explicit name is provided, cma_new_area() falls back to
> generating one via snprintf(), but the format string contains an
> embedded newline: "cma%d\n". This name is used as-is for the area's
> sysfs entry (cma_sysfs.c) and debugfs directory (cma_debug.c), so
> every auto-named CMA area ends up with a newline embedded in its
> sysfs/debugfs name.
> 
> Drop the stray newline and the extra space after the size argument.
> 
> Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
> ---
>  mm/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index a13ce4999b39..092cbb8f27ec 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -240,7 +240,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
>  	if (name)
>  		strscpy(cma->name, name);
>  	else
> -		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
> +		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);
>  
>  	cma->available_count = cma->count = size >> PAGE_SHIFT;
>  	cma->order_per_bit = order_per_bit;

Hi,

please see

https://lore.kernel.org/r/20260810093215.91419-1-hongfu.li@linux.dev

-- 
Cheers,

David

