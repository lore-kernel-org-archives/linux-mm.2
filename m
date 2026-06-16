Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B15CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26F86B008C; Tue, 16 Jun 2026 17:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF796B009B; Tue, 16 Jun 2026 17:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96DE6B009D; Tue, 16 Jun 2026 17:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 744086B008C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:39:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 021EAA0165
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:41:14 +0000 (UTC)
X-FDA: 84886189710.16.01C03F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 30D821A0009
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:41:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+dMyBHR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781624473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fXKQZ62YbUSWMyHmi4buCG/RQAWQXgAM+XKOF1miWg=;
	b=EK4dqM3RYgJLqiqCp1GXZizb1GHycl3Eeeexj9KJ1Z5E3Z94XnGTiGXfQhzFwXfOw0Prct
	U1ofv7iFcl0QczSOupzl97TSSwFKQHKZzCk0X6W3/hvmRlsKh+ZCC3eui/fVXJ9Ezh+Wbp
	5nMjYbJfUiOF5GZ7hbZZYXAKXPaFGhk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+dMyBHR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781624473;
	b=Lm1KwQzGv/YsqC7NSfdB/Ec5Cuzq0KPJOdS4aWQb50VubhwEO8r6ydjzyvuBT1dP2xuRBI
	3HqGfCpbVTY1kXKdEY+7Izs2KpzVO5aW/LJdA6zegbUSfV/jjSlmswD+fFbJv/NYUV9Cz8
	qvRAeSZIyWRUNY+5jmfryoAaCr8F5q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E19D60141;
	Tue, 16 Jun 2026 15:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1D11F00A3A;
	Tue, 16 Jun 2026 15:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781624470;
	bh=4fXKQZ62YbUSWMyHmi4buCG/RQAWQXgAM+XKOF1miWg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b+dMyBHR6oRMk34jYJ5+9hacn+vl4i1HjkIPv1VdV5hCcpOveE1k5rHWYZP61ieb8
	 lSPbvU43se8+w/uZKjFucWKa6QWOcFQHbUSv3osbRweZaZzBxF2KtyLss3gOf8WlkE
	 x8s2dvTpbY0NpBBgVv8zOFzuccrAjYLHMy8cSIXCzRxfQbhx+YOhMA4EW9hccdMDQX
	 yuRDK6VHPKv8P/D6uQKOuiccx2+s713o5GAmFuyPEKSWaxGBy7/oB0/u5raXeJ/KmX
	 1ccIijXynm3jy2p7h2cH+Az7bsSvtwfLAdcVeHiHKPfWaAVV+wzzmglsG+bLMhBf/B
	 bxNI5Sn2wa+2Q==
Message-ID: <e026ab6b-aee2-48e7-9bb5-1735d7a23859@kernel.org>
Date: Tue, 16 Jun 2026 17:41:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 02/24] set_memory: Introduce set_memory_pkey() stub
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-2-eaaacdacc67c@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526-kpkeys-v8-2-eaaacdacc67c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 30D821A0009
X-Stat-Signature: kzo33r6gu3m74x811yg9mmohb5zy5axf
X-HE-Tag: 1781624473-943810
X-HE-Meta: U2FsdGVkX18ee9ZMwm4Q1QqJCKjnLR5wTlzZQ5zqJ+Bksx2bcqJV0A5uPCRGug12Mui3+1jEwNH6lN6YRwHn+TBHPl40RUAnblmir0HqafB6x2RaFYkfhW0KMniTne/FZWCVfPknLJhJ06do+FgiVLSY83MTd/qMp9FEDh0gU3HtDvQPmZ7IzbiRVcnlM89DjtydxCRhb+BFyF0S+nlZ7yGixKYMEYn40teqN//rrzrQw4WIvmZuflJ6YdgDVZoyVpiE5Yk27ygkC0vYgI7WXEjFYZ9jtcY+R1gZ2E7tR4XRcvokxUolB46pcwo9b2tTOIqthon7PWuFyhQW16ZRKPa5QXX6OeolAP4ot645jxcYHT3osDcc/w754tQfWh3goQ/9y0E+xYRG7T2qHl2CZ7hY9xBScCk9dOxJ7cuCmbefw35q7S2d1SsrfiiOtdqeSuw7mnLNNcDfp6x6PhbOx4igMMalECTOQYkxKN08NW6OU3IPDG+fvkDyeEl/Vz6dwWaLyZRMgJ7QOsOQFbLfpowT5TrwFZJDC7ahP/nYLeB1cO4uNL7wb4XuZQKVZFGAI8kNKMEsm6FX/92XKnpcFdzs5mEqZ+NBsGtQ+yvqjb7axrVu4rxuVlKaolbOKjGrHikfQlkTiIuUlKrftBqw1mmPiPyeL2Ai1CHoBlb9SDp3WRSvycyFRFtB6qrU6zJ8ie5tap/FyUuYwRlERrrM0EREv+Tum7UrA2KcawEbPVIqMgRAj+csZrVOndyGhWjHiljQ2iVbZgPJTH4PMFPWKpyJogq1Q2bys64oQIRpz/qMfS09Umi+3hi07QW4pvpInz12+HFCOsW0IhPk1bLoTLlegXG7SwobpwUxjcx19e7mPmvPw68zPdv5WJ/yvK7UMxQi3PeAap7W5+ey9zMUofKlN4FBszR1q3YhPdUyckNhYqqpL+4yHCR7Qos0tOOI23CuG3gAjehx9qMaHCc
 knbvQ/2u
 igdO3GhpWWxcO2mtGXzhj5jm3q0vUtEDeKQhkCyRF9BKl3eNE23Hyc2z25iAOzTG0xQ5S8mN15Rj7C0DNGWLxOMA9gUDkrFRRebnuEvXyCfXQHWzQ6MlxYet6FltDpZTfW/QYqofLU88wTC2LhA613HzDgjolki1gu/nD3hVUOP7GODOgadC/mCaQDLCOGUBqbC7Hm00IMLRF8BuCGnhGk8fKCZRyKjZ1zmktnZ/WCg6Od169MjrTAx+9/feX1MsIbW4uwYks9LIBMDjrpvYa9YmEiP42iRSv7ZH+XruBiLNqnosPBO3GFHVX0n8VxtphYQTsICst1ZDdJX3ErU6ncrp4bkDKhfUQXxFPEXNNyUD9iKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:15, Kevin Brodsky wrote:
> Introduce a new function, set_memory_pkey(), which sets the
> protection key (pkey) of pages in the specified linear mapping
> range. Architectures implementing kernel pkeys (kpkeys) must
> provide a suitable implementation; an empty stub is added as
> fallback.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  include/linux/set_memory.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..7b3a8bfde3c6 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
>  }
>  #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
>  
> +#ifndef CONFIG_ARCH_HAS_KPKEYS
> +static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif /* _LINUX_SET_MEMORY_H_ */
> 

This patch looks rather odd, given that this is just a stub that won't be used
before patch #20.

And there, it's only used from arm64 code? So why do we need the common-code stub?

-- 
Cheers,

David

