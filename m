Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666D2606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=u2jgpdyY
Received: by kanga.kvack.org (Postfix)
	id 6B0BB6B05B7; Wed, 18 Nov 2026 11:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AF66B05B9; Wed, 18 Nov 2026 11:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBBE6B05BA; Wed, 18 Nov 2026 11:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24FC86B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:13:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BFF8807F6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:13:55 +0000 (UTC)
X-FDA: 85448736030.02.4417759
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id C13E520008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:13:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u2jgpdyY;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018434;
	b=MP9kcE4659bV8zQw7y3NaNYT09duPJ2sx5n/JhFh1OASWSFz8grA9OBDoTCVEqiYBzzuJA
	YiM2XotIriqoJLgeWXZ67+gyZ67Vqa51XrslIeb7eAtHqF6waTjISJPkzISjC73sBFOGYI
	+JDMlzTLoEamlnCUrnTUK/gHQhgpeig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDY6LeieQk2sGbGiXNXbPPvHnTeUTEIgT8C3oVSPieo=;
	b=3yMPQiZm/3i5ALI9A13i2jXaFjI0Dtr8n2M/ncap/Mm9nJ5USTcDDski2Z1l4uaHokHPvw
	8VRmKTmHUNZfGUCwx6IflcD1r/YTecbrPJe8Yeyl6La8JBodMt5Zellg5poiq0Otm+7RDr
	qehcMzA9xcvp8BvL3msbWTLCqT2te+s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u2jgpdyY;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06319339;
	Wed, 18 Nov 2026 08:13:50 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9299A3F673;
	Wed, 18 Nov 2026 08:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795018432; bh=pfB2+G/VoDxmSSgbbYNYneQ5JEOWrzBbTorN+tE3j/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u2jgpdyY1nx7ZxYgQWIL3DzdxEuJutCwltNdY9EaAvsqO7brLg/j9Ns2PQsLZ/HSU
	 XeHOk9QoYMskJGgkCIAx72cG40jDuYx8DscQhcxP2wcxdDgFxzww0/VW0HR0BrbSgd
	 IErEv2HBX5ors7qzipqCaYh4j3YMg7HC1YIBqcKA=
Message-ID: <9144c79b-4052-4794-94cb-51477ba91cf2@arm.com>
Date: Wed, 18 Nov 2026 21:43:43 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 3/5] mm/swap: remove unused folio_to_swp_tb()
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C13E520008
X-Rspam-User:
X-Stat-Signature: crbwuqqi474qtx1yrbe9f3rb5cf19gax
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795018433-801387
X-HE-Meta: U2FsdGVkX199pODAhi80hOCr0ijgeCmXMK5Xk2PpoXXrS4H3NLlK+vSKdyE8fK/C4r4ULzh2LCh5D+i39J1uXad5TVyD9Dr2wqn9V1GlJZsNoDRG0SXuYy843yFOlNOO8ppZ4mrjy3gZp84DlmtwU1cTzLJ+LkE+cahAsfH7TCb+/oarzqXcx0wcXixNIPgQDaYO6dHkLx9AknRmB87e1H4HLp5doI2UvDA9mcfb2UZX3lyXSG2CSfebJB/f/hQ4qqsSepMqDV3M8FZJrph3hK5z2snUSQnLxzz8dfWzme3kWh8WgArnZGsoln3LPEyhKVjRmLnfKtLs/n4mKFoiIz0IKJJ6pRMoIj4Nk9ZcgUhUefjK38zbr840FmHK8+vge5WRR+iAb2w0RzsFIulz/XIJU8Qan7I5SjPX/7dT5M6cR2lUtTQH/pVJ7nOorrw70BOwkySOQRDYZRaWiSYPvQnCLG4i4aGm1BcEsloIl5u42tQl9lREg/m/Q2yjiLhMxp/rZ1piiJdRZWHY7NoUTk0ArJiLP5Vliq4azG2micq9Sr3RezgpCbFc+hw7WcM5XHVP+t58kPwfb/2754tJHug3ujYh4EkQBO05qQJzdGNdIBZWnU82oHimwSC66663BZR9Tg+4rOXj8htzfC10uBkkyC3igZ8jph+5SrUOIRSuQxW6EubT77H4EWJsdga/Go/rxefscjiZecj7NdPFLYwqX/cJEzKaJeH3FFSfEuHxeaEuQkh3BnJSzfXRHdAj2bDqke2WmknilKRWVpQ341SiYoXu55K257BrJ5wFvHG92H10OcDJxRkvhnVnGoAqg9K+7twlpHSfM2xU+OQOADhUfYarPo4q76fqh17ir3FiZU67HmxAMoxB6AKR/T7eLiycYM8yE/3ET4yrOqxt4/1HBnnQddUFHR8Kwk6NCZxk8+EnSi2iRGYnSo9GdFT2t+OhzCHDOEZaf3CrlV/
 G/1LXOXN
 C/azujg6yBiFnoy587rj1gmZguTwVYgbQoqZS0SGtQqmXmEAoMEYdMdrYrUNKCxSIfglQafzvvMHb7mhwwAzvx86ubOuo07Z/lZtTqKkhAidH5vvLiHcWV2kLAO/Kl1qvHwmJ4I3QXcf/P9k0jUoxWDjUmLS6GtcfEpvcazsZsCjZTjIENV3KjlICnzK+koXGQNxZrvbOVQ49LQUeWU6X2TPNCblUVFhSxRBwqVENZ4+DGVsXX/IzHqYxcjlUfkPozOCvMSvqVIuxsykmXEsQMQQcz/h4kxgeJySu/loZ/V1NWZ9VvCWOQ7TUiJYt1XOrl49sThOwLKUcHc9eGv4lM/pMneamtafN4mZCG53fmlinucDrqvowgrGnp539QjiTnqNB6D8+6genX+mJpQoAmeWuL2pXvUGOmgmu3GpfO1GLRVQwMe/0MERICMt7E8deE/Hdh+64rXxE84KD/juvrkIjZ5ivCfDKdmm+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 12:46 pm, Shivank Garg wrote:
> Its last users were removed in commit 0d6af9bcf383 ("mm, swap: use the
> swap table to track the swap count").
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/swap_table.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index 072625d60d54..022d2251884e 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -135,11 +135,6 @@ static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned char flags
>  	return swp_tb | __flags_to_swp_tb(flags);
>  }
>  
> -static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned char flags)
> -{
> -	return pfn_to_swp_tb(folio_pfn(folio), flags);
> -}
> -
>  static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned char flags)
>  {
>  	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=
> 


