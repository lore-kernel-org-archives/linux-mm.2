Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79924C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1496B0127; Wed, 12 Aug 2026 06:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773306B013B; Wed, 12 Aug 2026 06:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661AB6B013D; Wed, 12 Aug 2026 06:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E79F6B0127
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:58:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7EC3140270
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:58:13 +0000 (UTC)
X-FDA: 85092318066.02.B226F47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 05FA840006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:58:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsaIE5hs;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532292;
	b=V1nU4Zu7rKuu5+UWTTEPAeVkXGc1NpaRkpaz2e+tMb428JKsfT9rrL4xfDYRCZwBG7JrWk
	VW+bYof4HEL48u/wMnF/EPPzTs43ESkAbB+0vD3qxv/JMUzVd9QHEe4YomDLPIshpsOQkj
	j3BdA99F/0t0OWaQUPG2Yh5X6sAOEbs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsaIE5hs;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/dvWIj0WiHmoWkLW9pLDekN4sILa8L7iFUCTv57xsw=;
	b=VeFR3xh++++BdX5vsNdsL1TvjVBnxxyuPiJv5czuY9agNmjR/evabmhnI4+AvDariyen2J
	swQWolc0RPt2SKclBiWE0BE1Q1SNdQO9k6SUMKgSAdMRLD4gXJi1DFpUOolvbz7uXm69xi
	F71qSK4XFl12WMDoOifQt2zT5etfrPM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 955D3600E2;
	Wed, 12 Aug 2026 10:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6D41F000E9;
	Wed, 12 Aug 2026 10:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532291;
	bh=7/dvWIj0WiHmoWkLW9pLDekN4sILa8L7iFUCTv57xsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NsaIE5hsgL1UwGKbNCNTYYd8Gt8pr0WW4g5C0pDZ65HSP1dKZzA0+GD/km6+PB5i7
	 D+zPEMAWsvfkleZ4YUb/Ui0k629vB2oss1cvtxGsJTchhwoTrv5psFX+Acc576uZDu
	 KE3ZKhRoONzwuoQHjMeHFAv55GbchVveKdY5THoUbRDXBN6i0SYvCmnZi51m5tV/MK
	 Ya9tiMFSgPiyy6CE5C+/JcnCLZO3VcpwxDYX/Q50gKOvxIfrnM8RuLqALP3SSZR/nh
	 1rV6pzNHmbJaNGc2QXAktye0aObcjhlSxdIMooIFm46lz6gmCYpdACE3abz/fDjUVD
	 Kn0ni3yY4EqaA==
Message-ID: <73935dc8-d501-4ff3-860e-640fb07d23aa@kernel.org>
Date: Wed, 12 Aug 2026 12:58:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
To: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
 linmiaohe@huawei.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, nao.horiguchi@gmail.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, gourry@gourry.net, tony.luck@intel.com,
 bp@alien8.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20260812091644.224299-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260812091644.224299-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 05FA840006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: eedtmdubknmunfmrsntgof87d36p4gkp
X-HE-Tag: 1786532291-744482
X-HE-Meta: U2FsdGVkX19lJ7KywY7HPAp0vZpYmI1R0BvaqsuzE+taZV8IE3RMQbPaiHVE1rTYKYb43NYhNPB953B1ATDSYCgNagnRFdcT/Z8L5JYjW1dE/xlMb6x5hcqQpb667GbEOc9lIyWLiWPsH5YenLLD45VxsZA8uxhKkvBhNi1T5gTVxvAKmHAPADrEYMqIQ+n9TbC01+dmldRZwXQasoFwoKjgI1LuaJV7HdBwGeF/EndaVI2+SUz2f5NtGL8ZsUqjJOphiSj1oPzGtajysD68XkQDFLNabudYA57rdDssvDFZCFX9GoVxJLZEIT3to1s1PUU1xphKunUAk7QGy+pa/hXCdTHvVNNPmBBLN0bDU81phiqspp6Cgh1c+AxVjixnK/P2Wg7cn34b7VlFnAf55ahc/LkpF8sl52ludokrHdoJYtfr1XoSN02/pYk0gkN+a1AdtQJbt6YtG6TZUvXmcqepEHFq0nefkgC6GK3HQ6yCbR+V3XcFIgxB/zEwbLEWkjfnTfEL3E04vr+6TobXQKDLwtMV+lDomvbEgx9Sx5OkxMm34auB8PxP43mAK5nVyAMaz9M4pvZSqME5qES7yOkNo5OMbfSUvwa8WDf+3OLIyslFl5HAmAZ3TCe9G2Ma1KVGYkG+/bkAu9ueiJpdQvm8isCmEslCQM5TC3ZKbDGcH8Yd8m8N9GRQLmQ2Gls1jeIpqN5LDYBxOls/Gux4IZq6y+YBirZthyvZbvoLBf67JSSFuE3G37Z3bzPXXUWxatA4QJJxjDGUJSw8brqcAiKrl8OgxW72xkU9GJxU7pOVJfW5cSjLIRai6WPen0kXMeO1FZMOPBXUWx1hGRiup9s7BI6Wxc5nJRhrb/cHxXEeysWcZI8ZR4Oy5xvobx7nrXo2ZZys5tTISm+EswXT8FSMrJOx1BZonB9RZ9qmld+3TxEOkkil0qnAcFtJK6nQr5AaROoXfwEb+ox2UDA
 whMttKoo
 ZEBCGjiYOPLek/sf6Rak3eSvDBADAzp6dvMFlpzZV9uI0rCze9z3KfSxEd6zn7g9xitfaJasPhsVrFxPkBM8Jxg8oVAUmv7Qudn55Ek/tb/fFIV7qQ71YpiAoG5+Mutt2mhxK+Et36kEGqTwvGVxOfIzEoeGD72qC2ILLUjwB2LGTcteZwOBRoYL3xeiZjTPZ9sYwgzaSPgGohfZDW8e11/yXiBH7pSX/o2jYk3tIV6Oquh9IXRQge26z0xNIkA7M02DQDk77xtlSYlIjUsJu/LFL1+jInRtIKhR7jEusHI2X0YU+aCGRfj8WNOuu24ys5tGALODI5w+CEGGmyqUwXiqqT8zdQXtalNQhy/7dvbY2Ml13zIpisrVKJx8WqLA5d7VxaIhYysYA9G4yFEwmeFZ9VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 11:16, Xie Yuanbin wrote:
> Currently, memory-failure can be enabled without migration. However,
> migration cannot be selected by user when memory-failure is enabled.
> 
> Migration is very useful for soft_offline_page(), which may be triggered
> by correctable memory errors. Most of the anonymous or file-mapping
> faulty pages can be migrated to other healthy pages.
> 
> Allow user to select MIGRATION if MEMORY_FAILURE is enabled.
> Also, select MIGRATION by default if MEMORY_FAILURE is enabled.
> 
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
>  mm/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8a24c130d008..b4c217383b51 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -682,7 +682,8 @@ config NUMA_MIGRATION
>  	  demotion for memory tiering.
>  
>  config MIGRATION
> -	bool
> +	bool "Enable page migration" if MEMORY_FAILURE	
> +	default y if MEMORY_FAILURE
>  	depends on MMU

As others raised, don't make this user-selectable. If some other config requires
this, glue it to that config.

Don't make it harder for users to figure out which mechanism A needs mechanism B
to be useful :)

-- 
Cheers,

David

