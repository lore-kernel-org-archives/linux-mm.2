Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D648CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 17:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B6F6B00FD; Wed, 20 Aug 2025 13:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63246B00FE; Wed, 20 Aug 2025 13:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA10B6B00FF; Wed, 20 Aug 2025 13:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A372A6B00FD
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:07:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51E71138C5D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:07:16 +0000 (UTC)
X-FDA: 83797766472.02.6F52465
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 199701C0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:07:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="R/9SvcRf"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755709634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qayB9LeR+RX6qridAjwC/zM9VoXQvXrNVT4vZTRfnEA=;
	b=HYxVITVV52GM7nX1EeVXHkT7/WniNViryAvjgcYz4QvlbSoGZKELq7yqpVqn10o3te2Qg9
	vq3+YnTtw62bTTB7YFQaOkj8aZRfOAZn2LZZRoHJE+LdcknOdACQtZyBkGvFljfmOTmTVe
	YRFjdrYDstW9bQaAFY7e87vJrfm4WI8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="R/9SvcRf";
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755709634; a=rsa-sha256;
	cv=none;
	b=XI7tGsVlBVDTocW/cFC7KjG13wgqNaNtY46wXinPku3P45priA7oxZ930p27wnzmIvIaRs
	WisvBz374rb5K+XaA8loBMM71is7k/aBKYwtVQC0lp1MJyntZ6TcBA4ovTRBoKw2sf9RYR
	juCa/Ja0P+njhvZ/u+QBqSYOnOQLLZI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=qayB9LeR+RX6qridAjwC/zM9VoXQvXrNVT4vZTRfnEA=; b=R/9SvcRfJuRvlkls/k6xHiZo0X
	7JJOUj/v+RIkIQ3mpC3FpeaiwocGruY1eprsKXh06G8RTQcg5BAQTeprwpvLcw4Mi8DmFYXTFgEdM
	R0JZ7nWeBSdQngpgJTmRBhg0RtStcBJOJaHl0CrcWj1wApC62jEkVYeDLiUJ0YNfheUyM+3NbDgVk
	mBRPhB+APpGklJ7AQyKqWdv5YlxKFmReO9DU1jffLEvPUGP1oKzNXeC9HkH99Er6Iw+K7Fv6gq9M3
	Wp6KGkNzn+Ea767MMcS0lG6kMbPI5qWa+JxC+1jxfYqL26wuFOSF3kY56cfDDhYAqM1Wc7wp/yMyv
	Gdjhnkhw==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uomHF-0000000ETuY-2LE7;
	Wed, 20 Aug 2025 17:07:09 +0000
Message-ID: <dc829b1a-f0d5-42b8-b128-e305a1ceb32b@infradead.org>
Date: Wed, 20 Aug 2025 10:07:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] acpi: PoC of Cache control via ACPI0019 and _DSM
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com,
 linux-cxl@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 Will Deacon <will@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, "H . Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Yicong Yang <yangyicong@huawei.com>, linuxarm@huawei.com,
 Yushan Wang <wangyushan12@huawei.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
 <20250820102950.175065-8-Jonathan.Cameron@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250820102950.175065-8-Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 199701C0002
X-Stat-Signature: 1oti4phrssxbme755jy1q1mg1rio4kgd
X-Rspam-User: 
X-HE-Tag: 1755709632-466969
X-HE-Meta: U2FsdGVkX1+tk5kMXVkY2QJ3jvtTJhseIdfUcusFMCceev0mxPKzlRu9Ee2x/36pNuQ9v1jkshykb1DxFIy9Q3MJqZMdb/B3k8+UFVxKYJac8yX++D4oRmusIC0HMUlE6AXUrxR4h2ebZAnBzMWsxO0d/rhNHAuBZn3TeeNU1OAhQ1XxNIPQK3y5iV+1rN2oiru8aAAD0lSbRDqBBYQFEjBnzLOw3w+4u23I4gmnryhh7QLsOoLIROrD8UcUW3ICs1eHRLTsou7Io7lc9nPxN2S3jh9ABy/j06/JnKXgzrkjlet25f1RLOWCLFumCNhNfvhpIuxqZC5jzwTGkjp/+MG3CiGdVudGERjyITSXlhWlb4UOegxi1QnjWMPm/qaeHJO7BCsno4wMN8CMIfFV05pSzEkRMXWKmkOVh8DmcAZQsm6Y2SjDIzBoqHF9XzkNUE1u9bTvhRSbF1y3v3PDJfAd8jA+nQ5o4YjW3vV2WLMSNbiNzU42Hl4Xbw6vicSyzqknQiMsEC+A0PmhOb7WNhW2e6Ojnytt/UyVM5A5FnmNVJzzbsgZFmoVP7RBd3GtDDDfsr9AVtCq1Z2SkKncm0ZfVRiMRyXy+RaRwrnGT2mcY397LPHDAuDTF/76CIA4VnCKyV5jJoaMaNTFzICH5/SNrM3gANOZoogxThnLNC3ndQdeM4lnmYDkUWCsaa8R9NTLAnqigNepzb2OFplueerXxtDNUYHFc1vdL9P/h7uuViB5vr628be7RJy4k5RXer6DpuWMx1okZvlYumrXecwwzv3F1CNGtOMfgpdAC4UCEt+h5G24QDQu4wZkLdVETyGfqWrbN/rCuktFLI0r9kotnBGY0RycSrFbSsLw44pzVhLenSURByQKqfe/ShbVOcq+7bZ8mBhoyftMVi4eCs4CG/sA87JJ6qe/ROTB43c5jGMbXXO9m1NQv+QK7q2fH+PrOFZ+s9yQ2LypqTT
 yDQTZtHg
 LlxytW+si+dKvuudDhZjwuOgoEjeMOfbugmcr2F0PFlUnuInwX6hNdbzCJMSN0/LqX0cZ85PzmG1BG+cI11glgzDGeYNbQGkiS1OFv7x1LOc0dDaQm+8s7DE9ckeRX43/3PVoH9S5IYbEcZzhmd6oVTv7Jf+3aEKMuJZSyTxePRUyHcRUC5h+8YFeg8RZuUfEeWj4LR9Fq7Jcfdvcolh+hr7OCRxwVNDONH1j2RCeSGfISGZVIl2T5ATJ/i7dG0dHaJTpZq2NBRPMZIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/20/25 3:29 AM, Jonathan Cameron wrote:
> diff --git a/drivers/cache/Kconfig b/drivers/cache/Kconfig
> index 4551b28e14dd..158d3819004e 100644
> --- a/drivers/cache/Kconfig
> +++ b/drivers/cache/Kconfig
> @@ -3,6 +3,13 @@ menu "Cache Drivers"
>  
>  if GENERIC_CPU_CACHE_MAINTENANCE
>  
> +config ACPI_CACHE_CONTROL
> +       tristate "ACPI cache maintenance"
> +       depends on ARM64 && ACPI
> +       help

If there is a v4, please use one tab to indent the 3 lines above.

> +         ACPI0019 device ID in DSDT identifies an interface that may be used

and tab + 2 spaces to indent the 1 line above.

> +	 to carry out certain forms of cache flush operation.

-- 
~Randy


