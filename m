Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 030B6C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94776B011C; Mon,  6 Jul 2026 05:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C449F6B011F; Mon,  6 Jul 2026 05:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35BB6B0120; Mon,  6 Jul 2026 05:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD4C6B011C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:13:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 207051A0347
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:13:55 +0000 (UTC)
X-FDA: 84957789630.10.C91B763
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5638420003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:13:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gifK1Ti/";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783329233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ELD/QV0x1kpN1PYPogRPMQ8Jugn3hQYtAP47s/qJMk=;
	b=70xy6ek95gYkOQWUPTPMbw7qnxl/GR8nA/BmYiwrwKbebs0LxWphFkZdQ3kR5gMDeKxAjO
	SyYqBVjqZLh5ETNXQm2F28qxHKqZbp4vVOf6h2AG0BoUCPo61CwX/pgoakKKymvmO92Vjt
	FXoedORKE9j+wG5O3HapGqrWlGxc26o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gifK1Ti/";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783329233;
	b=j4+8U74uqCyhbdAjAp1aRnXKM0s5MoLMpJGYmGQdDom7EL1w8q1SzLN2dh6hi9HTQxvsgH
	QuQqNplmREABi7gxBz94TyEaxiujwn1ALrEqzdAcJhCpy+HcwsiNabh0egt6Tiai0e/P16
	Eh6/OSe8OtWYqHCCb2JpfBOd7Qjzsvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C9724174A;
	Mon,  6 Jul 2026 09:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4751F000E9;
	Mon,  6 Jul 2026 09:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783329232;
	bh=8ELD/QV0x1kpN1PYPogRPMQ8Jugn3hQYtAP47s/qJMk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gifK1Ti/VgNSex0l9sLQuUuZpqcdPVUpCa5aG1GjioAJxNHU9wnKrZuzvodrfce5o
	 +2fMUkRg8wVr9tLGihB9hRmgu2LdPyMeLpzwfG8f4FI3hLloTDVfiJOmkQA59klUdD
	 xPnrsyUjuVfKruR8NR2jiRDVPaIHiL9WP6z8N1Z+4IeClzGWGDbwg4gjKyV4qoxp6v
	 8hDcXinuFA39qRkmfkC6UoGpU00pHf/19pnNKtB4o5o5Zk7RxHtfz6vHqxsWl3k2TG
	 lBtDw1xdUV5GaeHgFs07tXbu9uXpOQDVmJTT1N01przGF7zo/YhP0bDKf+yBUWpyV6
	 Il4A8a9nGgqJA==
Message-ID: <38919e81-4c35-4e8b-ba2a-8af8be60b0b6@kernel.org>
Date: Mon, 6 Jul 2026 11:13:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/8] mm: factor zone-device page init helpers out of
 __init_zone_device_page
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 apopple@nvidia.com, arnd@arndb.de, bp@alien8.de,
 dave.hansen@linux.intel.com, kees@kernel.org, mingo@redhat.com,
 rppt@kernel.org, tglx@kernel.org
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
 <20260701090553.62691-3-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701090553.62691-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5638420003
X-Stat-Signature: ts1heth3ooqdb36qdrujgj1m8a5kt5rq
X-HE-Tag: 1783329233-944407
X-HE-Meta: U2FsdGVkX19R99NNIQWpemntsK7Kyf/fC9IrAvdwc8hLvBSo6/zFzUvEXYtkmxsk8zLiO2LRFIK67zhqWDHKDMBLAPoClU3E5WB7KXMa82cp75XCiSBUFMQtWmU29A4GtBDD0Fu1vLKzBcs4bcaR3UIFozMtmwly7GMDsp0Y4gXyiM5xCESh/J/TcFAObvIoxvBs6g6RHjf/FsMJJfnL43RiwkOPplYTdpzxJqI78BSFzJdXRamBOmru7iG430bkxjHLdXiRvsUjeRHU/y+6KEOTBhMQCl55Xl0ENLbhkzCbXaNTCIuBXgXLWqELYnNB3JVGIzJixNtY/9rUyxR3yA+s0UAG/GwXbFSoQDuU5Kd2swQYPVUsOYUk3t8nSXw0EQ/tBRgWYGIEq3KIg6zKOkhYY193oVBb37I0AiPCcGdHEZdn9KaywF+4vkASR6hmbDrxnq7HkjL/UeP+sr+0E3xkc6sqgxmdM3Q2B8BhnBhBkmL4mKsYcyOYyNrGInO3XeUt1qrbyaqXnkKPoGvmt/unYqq1NnRzzfp4g6XUsU0efzhuSa2u95UOSfLANL02Rpr8roJFN2CQe9RVEkzRAF7yw0IgB0q3/J/qXRDolWQwhIFSewrcfa2qYcVMYLNNteoqwpNl0RYcw6g3CUI61fQyTe6a+svzhD8fVqwcbUXkcAX16gRyomqI7OnaHvd5v8R0J0Gh54VooSLv+JPBn8joqjgj8pvpRS3OOHX1jWtOT3ESTNBA/sC+NNEXO2vhI38iQG/Oef10UJbZI6ggq0n85fnTddDumu8BEtXNBpY4kIcxiDcvvDkx5GUnMcZTZGrKjVRvX00NFyGiA/+G0uXdf675GY+6NJ3zlgTxX5qqA8DdUYO8CdTIov/gDf+F4XTj2gQ0y6hdt+Uo57zDD/dc2GXn2o/CI8yPJYVwtTOkA2u36tYW3EOlVGuN9FyYQBlpCpbcoQs7ZxHrCpM
 +Z3HZJIL
 S6cvDEMXbXxLwfaWOsbzAfPRTln4vG9cJjP/u0CTs56a6zaiIgBpAaCN5nXyqzuMdsMHMO2OnukSav03Mzi6ftyMplAo7DqsmhYd2FOOyxPujlSOxyXXNiwR8/+Cm6T2ZYG4B3Lhrhv98lVO8qfjmuKqF97nLkve8Rz2Jb6ZEhkw9tvjCDFoB/24+RqkqLSpEINN5M7QG4u8ScSEi12DgROFJW3y0I/jCr8liEdH+lvvV4Gg81wXovDxwarUOf9XcJScqp6d+yUwJwD78FHiAxg4sqr1xUrs5DEzCZ/gpN0UXHWJiMQRrAg0CT6ORjIT97xnpw3sGbCcN5xfsL8gNTVBPKP0wsy2YManS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 11:05, Li Zhe wrote:
> memmap_init_zone_device() currently mixes refcount policy and core
> ZONE_DEVICE page setup in a single helper.
> 
> Factor the refcount-reset predicate into pagemap_resets_refcount(), move
> the common page initialization into __zone_device_page_init(), and wrap
> the existing slow path in zone_device_page_init_slow().
> 
> This keeps the slow-path behaviour unchanged and gives later patches
> reusable helper boundaries.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/mm_init.c | 57 ++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 38 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 95808ab5cfdb..4c7fad440c2a 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1005,11 +1005,38 @@ static void __init memmap_init(void)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> +/*
> + * Return true when the free path for this pagemap type restores the page
> + * refcount to 1, so memmap_init_zone_device() can keep the count set by
> + * __init_single_page(). Otherwise initialize the refcount to 0 and leave
> + * it to the allocator or pgmap callbacks to raise it when the page is
> + * handed out again.
> + */
> +static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
> +{
> +	/*
> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> +	 * the count again when the allocator or driver hands the page out.
> +	 */
> +	switch (pgmap->type) {
> +	case MEMORY_DEVICE_FS_DAX:
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_COHERENT:
> +	case MEMORY_DEVICE_PCI_P2PDMA:
> +		return false;
> +	case MEMORY_DEVICE_GENERIC:
> +		return true;
> +	default:
> +		WARN_ONCE(1, "Unknown memory type!");
> +		return true;

Wouldn't the compiler warn if we would define a new type but forgot to update it
here? We're using an enum, and I thought the compiler would bail out in that case.

Or are we scared of some other garbage ending up in there?

Apart from that LGTM.

-- 
Cheers,

David

