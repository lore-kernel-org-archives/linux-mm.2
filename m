Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 954E1C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985176B0099; Thu, 27 Aug 2026 03:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95BDE6B009B; Thu, 27 Aug 2026 03:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899736B009D; Thu, 27 Aug 2026 03:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 690E86B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:35:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64DE81A033C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:35:35 +0000 (UTC)
X-FDA: 85146239430.17.07F0ADB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A6144100002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:35:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PZpay+0/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nL4Ln7o3L3IwaxI7h6hlZoYQGbFSaz6OPobG3bCfCTk=;
	b=WbNQchslqbWrEQdDU5APlqpJgGtQqOYdAlN94igR2oMV9JMOoX4k3elK+9mx46WhqBRyNL
	wKaSHQA5ZToOIl1W95C7kv1m2RPZJ5Nn5xXGqY0Wo3PR/6Q2ZKCDgfEb04JK2n0N64LJmr
	0n4Ox1IkWIcQuzUG+nMIh0vC3FZN4C4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PZpay+0/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816133;
	b=7qgNYjRKsZBLXEkcq3cFPihqkIXu+EMVCMGBjv4BIDVuF6Zodj6r/6x5UmLLtdFqLehM4+
	+diqmvwxKSrDhjoVPn2M3VyIELLI++3bGm1wUahFyPTXTLUxwpxWX61qE/ITnFXmOxPY/C
	qF8eZq6Ho5vO8imgXMJdv3rAFYP/uvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC81643BD2;
	Thu, 27 Aug 2026 07:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823C61F000E9;
	Thu, 27 Aug 2026 07:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787816132;
	bh=nL4Ln7o3L3IwaxI7h6hlZoYQGbFSaz6OPobG3bCfCTk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PZpay+0/KaEIqQP15SEKPTm5Fk3ioRb/SL1/MOWCWmeA48skcWKwCM3rYAuw/kq1v
	 4nQCIUNBDJ7WEHwVaiEeIZSuy7Dc0oJ9+yRXLHkNzvSR3ASB+kS5NANaqcp3piOSCh
	 fMXwr1yEKtbdMHDAMgKrTBDNrDOEyqZvGhbsc2Q7jVeOJSVIDKMl/bdAEDYcU5Rvtw
	 WAMRfjGKc4Fcs6FN/Hji+RgFEricEu8K0z8+kM9UZ3z/gENvgIkiFlHioc1u2cqMuP
	 Pg85fhnzJ+s6SG/2JRuaposCZ5kTaFalhWIRecU0GwVC12j9+xu7Lq3VCV0A4MTlJO
	 K5qyQHwUqrmGg==
Message-ID: <cbc344a4-77b7-4282-9bdd-004822642ab5@kernel.org>
Date: Thu, 27 Aug 2026 09:35:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove out-dated document of __GFP_NOFAIL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baokun Li <libaokun1@huawei.com>
References: <20260827030548.16631-1-richard.weiyang@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260827030548.16631-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wjfakot9ej4yf6b16a76yacmn6jfho5j
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6144100002
X-Rspam-User: 
X-HE-Tag: 1787816133-487129
X-HE-Meta: U2FsdGVkX18GerifJ579iK9XMCHEcgmc5gFQTnz/obVGy9PatDAZfU/Pqook8G08JiWn9hjhDKdSxk+3pdk7Cr34F7AAwUOrKwJ4h5N++KpzrYI3btFpDC4hjsh9kaPzrp1RYoh+KTJLSsHrIC1VDfzXb1tWpxPfG+5UQyMEJPBiim7osKn8J2B4kBCy/iTMotl0NcXxi5V+qR2zFv1F7Qrw1gryiNQUxhkFtzRe24TtajUsgfk6Wf55toRmBbKfa5TKADzMG/EZHSrObtHKy9xGiMOKU2nbeoJifSWphznemp07ijGsJxVm0mW8DC9IaZ5r7wMUCScJk4km42d+u+GhWjePzNL68Xm+3bwj5NU66Qcc6PfPcW8Fb/CSTz6fMGJKAsAUu/4vkrlvpGehLoBtcCokqVzxYJHLI6uh/p2i/oDacbFTbvyXFWLBp7wB3ArlcJe1kpuNHuynZf67xXFXnwlsE6392ocvOoloKYTspiqOfhk9UavtBdHcDbqNR/4j3i5LzEiIDMglz0vXdX8qq7WeM/L8wSe7eTx7Y3jJ4wL2OH+EohCymsAwjs6VEWjP2uzpUu3hi8cB1CRKfTqNVS9NpYgq0gXtaDaXJWEuXS9ilQeBVQBC0cwYK/yLvxE7Z0NGJFUe96eqTtzk8oanj7O5gJDu7fDgCSi9pHSF0WVO2NR7Itj2/1Ny5kyz4Az/IO/y3sBGrvgf5+Ga+AuNntpQEmTeWPOhc/kKE3qu2YlMUh2k6dhInvP5JabIDYIwk6SVtoQ72zM6hZWo7bA15fX7XAS95lsBGsMFPWmYgyLLB4wY7rm69pGDMyF8fM0O+0VmITdwTnZ6/qo3RsE/isB5AG2uwkgsCuaQuIB9kOIuZjKQwP7x0ShhqdNZHuAl1cA3zUA+d0djZQ1DQOd/d/pWPreHZNYfBraDaMOl8nt29LYDV8DEWtZNCr+jsVhdYuxnHT7TaKaqlye
 yD9VPPq2
 V2dkdTQ9YOfccCoggw439uPsMysIZee1j/QqbWDRtsOJPr8fhaV4FyHJavSYh9tUmsSQvgPRB1FCar5sMXCjnD8NpmXGwYBMPzj0SyOKt80/b4c8VB4FpNkil/dWKABXNBuDRyeD3RZnC06Gv3mvgDWtfRngegMzs41K+ZW0WqG55U8aIk9xTSYZK38ucH2wIzOmXt8xgGLO7IUJ7OnIUR+7Tx3AlJ4+w+1YCH2mCrjDdn2H1phX0s4k9qaC98FSxH5jejJq8ujjIw9iy9R/BwobhdiAdxKzTAB9fbGwjUnZ8qKxH6Jxmng2UcxsmIl8W9C4tt7iQ9jhRdXzFFa5ULaYUgDESdCcgxIeUZogHFPejcUDsyUUOjczK4UrdofeA6U7UaJaxKtSjbZMGDDmrJKVLCJXuZViqMw1oyCH67TQa40I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 5:05 AM, Wei Yang wrote:
> Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
> with __GFP_NOFAIL") remove a warning on allocating large folio with
> __GFP_NOFAIL, which is adjusted by commit 903edea6c53f ("mm: warn about
> illegal __GFP_NOFAIL usage in a more appropriate location and manner").

"which is adjusted by commit" sounds as 903edea6c53f came later than
ee040cbd6e48, but it's the opposite. Maybe say "which was placed there"?

> While in that commit, it also documented this behavior which is
> out-dated now.
> 
> Adjust the document to align to current code, and adjust the comment
> while at it.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Baokun Li <libaokun1@huawei.com>
> ---
>  include/linux/gfp_types.h | 2 --
>  mm/page_alloc.c           | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 190191411009..24fde8eb73df 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -243,8 +243,6 @@ enum {
>   * used only when there is no reasonable failure policy) but it is
>   * definitely preferable to use the flag rather than opencode endless
>   * loop around allocator.
> - * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
> - * not supported. Please consider using kvmalloc() instead.

I'm not sure if we want to simply remove the lines, or rather say it's
discouraged (instead of not supported) and still suggest kvmalloc() if
possible.

>   */
>  #define __GFP_IO	((__force gfp_t)___GFP_IO)
>  #define __GFP_FS	((__force gfp_t)___GFP_FS)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ab385bc252cc..146f7e0a9462 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  
>  	if (unlikely(nofail)) {
>  		/*
> -		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> +		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>  		 * otherwise, we may result in lockup.
>  		 */
>  		WARN_ON_ONCE(!can_direct_reclaim);


