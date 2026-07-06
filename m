Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE4EC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A4B6B011A; Mon,  6 Jul 2026 05:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A566B011E; Mon,  6 Jul 2026 05:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828E16B011F; Mon,  6 Jul 2026 05:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 560AE6B011A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:15:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6DFD120366
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:15:44 +0000 (UTC)
X-FDA: 84957794208.19.2AAC76E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id EB06C20006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:15:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuHdcLS1;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783329343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bokzjo0yW55RfvluZv8dBD0vpjCIgsPtps5JnOgTFww=;
	b=zLhMoLGdO8o2UFFMsUnQeMUmxdnPFOiz/waTnBA7E5GiB858N4n/z93TxJlNXG5DgRf1e/
	8sAW7mX7TciiAsiZrh9ZYeCv76Fp2vB+pzjkUuPUq18/wXKAGGVLTMFUfHNSXzncMpnt4O
	1GVNQjwHSoOE8A1nae6VPU80CMEFSIk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuHdcLS1;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783329343;
	b=eGgHYz+elUrfR/zDp8xEwaAu1emS8iFYg9ul4I/WPYzvGOwXIgHPgYRy+CZr2i7k7dqSc2
	E59v/sS1xrBcL4AyXE2V3nQfJ3/rQ8Xs7d8YRKprNcQoDS3gjiKtmFvwrqXtfQfB3k81DG
	xHYD5eb232Fi1SWVHlz8OSafooV6KLc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01BEA41814;
	Mon,  6 Jul 2026 09:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6B81F000E9;
	Mon,  6 Jul 2026 09:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783329341;
	bh=bokzjo0yW55RfvluZv8dBD0vpjCIgsPtps5JnOgTFww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PuHdcLS1JTZ9/r5Mr4tauz++6saoXfkiZkpk17nVpbDKcJKf9cDmGBG5lRKa/b/cb
	 m5aHsmlaHkT+ptUZkhSvSlQLJ7I1GpFf0JpcIljNfrqqgYpiDBhQjkzQXsateYVWg+
	 4FbzPzDDVXQjKSZ4+QTp7H2efjV4RdUOuR66Yb4kMI2VtBUj2/PlFtkJuSJYmjilVs
	 RjSM2dUGGPJG7cvGItYbpQ/80J9wMK/LFMss6b+pi2qO4Q6AkoARLZVCO4kB3OKEej
	 tA48zarkJbc+ndBT2e7reXXpM6FTtuqmG3Iu3b7Frg7nZbVhCMEUpDg4YXVhzR49jd
	 w68UsR7xZn/nw==
Message-ID: <8a6f0bc0-5b6d-406d-9d2c-d3861b5c31b5@kernel.org>
Date: Mon, 6 Jul 2026 11:15:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/8] mm: add a set_page_section_from_pfn() helper
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 apopple@nvidia.com, arnd@arndb.de, bp@alien8.de,
 dave.hansen@linux.intel.com, kees@kernel.org, mingo@redhat.com,
 rppt@kernel.org, tglx@kernel.org
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
 <20260701090553.62691-4-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701090553.62691-4-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB06C20006
X-Stat-Signature: y7jk354pegpemhf8cfuyx3ziq3cxsggh
X-HE-Tag: 1783329342-172124
X-HE-Meta: U2FsdGVkX1/liFcNL5ebobCQxUTL/nl8lf+6wjVvJVADebqGXPbKUW1SlCSa2tqaoufalivc7DV5jNVArN2frZCvelFEKyrlhJLkyR3ygKFUBUYM4JSHqwCU7FvQ4tfQ1gpNpZ9oZgBVlZagZ62CG1rdUJ3reuLHu4cAxci3rdMHX9Ko75izCmNkd9eZMkCiLp2flk7ZNrHtWjZWPndRK7t3IWD131PauhkNhnvEzSiEGoOr7BYNeon8/cCDw6zukE2ABSzWD6r7+zQkpQ9j5eZ92jZxjK6cVbWKOzrJVwXKWHr7/n4OoduGwfneYmhvctIHe2netqj9DGe4bEDEDNRk8AHmgTIGB5gfXWBBkm7LUgXGkbY5KJip3OqeDaw+mIFY/k4Oq04bQAG6dtoJSZNmWj8XHWUvzmDJRBmTYSrWgzYYATEfRvadNeWAyWRDb948KPI7VP1SYdsVyUEr2PK8qmfvktmYrsHhR1QuxBy+YhQqnQv5XTzTVZPLHROlVonnfJ5FoG5SKZkliaNncvMVJTZiCssSfbDLgyPfqMhxtsuaDUZNhy3PqtIbzSmEU7i+zK7wWymWiaWhPQnQ82PRciHtyOmKi+lzOdZhtBxq6PONXvG9B9+AZbmLRLD7oWsv8oRXLF89qMmmisz+Yv4tqiDVWVTBjzkj2KoXcdGQxNl/dz9jc0/fJ8fEsuI2b0s5/dH7ngBL7omvTm6XqTccWrlrqG7TdrJtqsneuMyttCIej/5FU4z4/qW2dnQxcp8Z9vK4EZmBX1bMeFDf/o2UNfba98ho62jJsU0yoZlAcJ+fr/bq2SG77NnWdGQF2Z+MfGj0b6ZH1Cy8BSrPVCK7/E8YoxrZZT86jvUhiQSilcWo+n9FS0YsqSsKNqzSxKxNpCPN6weA8TpQY3OpYMpwPC4ePyl1KWSpEn1ml0UGYmxa/qjaWQyby/QQJxKjgIpqoS0ncXMiHrshXhB
 mYSZcbQB
 6a3fmE1KbjN45x/PqKXFcEIte0PU1EG3axJ3w5W+A9n2uE24t2GVrdH99bKF60HGZxhMwVoTu/PUh1WITxLo4vMsIfjEiP/XK07OpkxzU4lTXTXTNFqK97uShAmTd3y+27Idseo1/js8Y0t61CyWLbjwpjBz7rkkfHkVdr57fjG2nTnLFkw0Q7IHkVYLjE0jYiXe4RGqtYmpSlXu6R7ruiQJ7nnFG51E5hPJl0ijBnOr6i0meAvg6x/HtNbm6HDal8Om0DSyfF3nC2EBnrn/fkw5Eu/wVL/ccQDSymkrVXFAVFvPahrjVbSuOeo3BlTYYoZcyJHM+wrLp7Yrqm3WUIIrl+l3PdnQBquRA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 11:05, Li Zhe wrote:
> Callers that want to update section bits from a PFN currently need to
> open-code:
> 
> 	set_page_section(page, pfn_to_section_nr(pfn));
> 
> and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.
> 
> Add set_page_section_from_pfn() to wrap that update in one place. When
> section bits are stored in page flags, the helper derives the section
> number from the PFN and updates the page flags. Otherwise it degrades to
> a no-op.
> 
> Convert set_page_links() to use the new helper so later ZONE_DEVICE
> fast-path patches can also update section bits without open-coding
> SECTION_IN_PAGE_FLAGS at each callsite.
> 
> This keeps the PFN-to-section translation local to the configurations
> that actually store section bits in struct page flags, and avoids
> exposing that detail to generic callers.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/mm.h | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..f78afa63dd3d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2541,11 +2541,26 @@ static inline void set_page_section(struct page *page, unsigned long section)
>  	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
>  }
>  
> +static inline void set_page_section_from_pfn(struct page *page,
> +					     unsigned long pfn)

Two tab indent.

> +{
> +	set_page_section(page, pfn_to_section_nr(pfn));
> +}
> +
>  static inline unsigned long memdesc_section(memdesc_flags_t mdf)
>  {
>  	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
>  #else /* !SECTION_IN_PAGE_FLAGS */
> +static inline void set_page_section(struct page *page, unsigned long section)
> +{
> +}

Why do we need this?

> +
> +static inline void set_page_section_from_pfn(struct page *page,
> +					     unsigned long pfn)
> +{
> +}

Dito.

> +
>  static inline unsigned long memdesc_section(memdesc_flags_t mdf)
>  {
>  	return 0;
> @@ -2768,9 +2783,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
>  {
>  	set_page_zone(page, zone);
>  	set_page_node(page, node);
> -#ifdef SECTION_IN_PAGE_FLAGS
> -	set_page_section(page, pfn_to_section_nr(pfn));
> -#endif
> +	set_page_section_from_pfn(page, pfn);
>  }
>  
>  /**


-- 
Cheers,

David

