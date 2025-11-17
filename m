Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C4F1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4BA68E0028; Mon, 17 Nov 2025 13:51:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B237E8E0027; Mon, 17 Nov 2025 13:51:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60348E0028; Mon, 17 Nov 2025 13:51:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC2B8E0027
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:51:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B0ABB771A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:51:18 +0000 (UTC)
X-FDA: 84120991836.18.B79BDEF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id E0AAE40011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:51:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lSk8kQ2u;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763405476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aNsSoqL4Oh9FppblaXOE+GKfYhRL9+dtetncwBHI7I=;
	b=aAR9C5u0uNCuZa1+EjvY+8kO46wS9J2iUD1Frxhlxxv2p6kxo+HQ1fhCONWs9POmiVHNbo
	XtWs0ZL9VnCumcrRapD+FM3Yvy6skSyAIT44mS6XdQH6FjjrTY7G9z3SnE/WAAZPijzmfC
	5bcyaiNxgGTuhkYPKtQuglXp7F8a4sw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lSk8kQ2u;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763405476; a=rsa-sha256;
	cv=none;
	b=XLiQXcmKUjNla8MA7hxNGpamDEmibpF9Fo6QRl4XrWZ4Z3qr+FVYdSeC8zM1ExQN60Sd4t
	2Dc2GmnWllBWyD+9QWryg1gTTbh1DABeoMf1yvz6L3g3wxpzJ/rAqwIafDyP0v3FZIpe3R
	QKBajMaR6T8cNVKs62DEvS3e/iakimg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=7aNsSoqL4Oh9FppblaXOE+GKfYhRL9+dtetncwBHI7I=; b=lSk8kQ2uqPCfHJcpdG530/aCCq
	O14UG2HC5+fxKf5XeN0v+ppv0P4u9+RBP9YpGI1a5LDxmwzUBtpGJDmS+rLQ68GNJD8f0DKvhuoy/
	GQroSx1idJ6x7HDdAgVbHT5Tunx2PeqJZg5Z6kRzgJPlRf4ljfC9iXNBUAEHuIGYEote0t3nnPSuG
	BJoAEJNwGOCDH/5xx58ixucIcTUZhJJs1yTvdZC9DbaU/x2XjUPlV8PIfY//v+7q+IrHS2+WQcTze
	YkeXb0EGr5ryOu+SttJr4o7uES7Pq4mhbdO2QGFAfYg5GPWcH247xbr/4WeMPu16SoUGDN8RELLVX
	16fnJYMA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL4Jk-0000000Gflu-13Cq;
	Mon, 17 Nov 2025 18:51:12 +0000
Message-ID: <3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
Date: Mon, 17 Nov 2025 10:51:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/7] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Conor Dooley <conor@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-cxl@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 Dan Williams <dan.j.williams@intel.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Drew Fustini <fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: james.morse@arm.com, Will Deacon <will@kernel.org>,
 Davidlohr Bueso <dave@stgolabs.net>, linuxarm@huawei.com,
 Yushan Wang <wangyushan12@huawei.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
 <20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0AAE40011
X-Stat-Signature: wkwc17e3qkcpkay6jfxp5y5my8zhgaws
X-Rspam-User: 
X-HE-Tag: 1763405475-786278
X-HE-Meta: U2FsdGVkX18KLQsRZ8M7WILQPRC6bgKTpUkJvCXZoyXp8YWnyFeapy1lusZliz7BWsGa/KmZHsDf3pDJasTcavDmbJFhGufsGjXxdaWuSszt0/jW+bcLilQ8eT/GTR0jlPoOjaU7jUMhyFYiUH98lCUKyibmpzsaq1+A48Ob/wH+bzrpsR06Dmr3fmGCFMOItYzpuW5obDgDcbN5++q2XH539X4/357FrVWxh+xP0TLUus5sYXT7ZvGIfNh8IN1qL7V1wCjgx0p90qQ/m24mk+tRhvFdR48EwLkO1aQszcvb/fa+k7NQaYNpdd13m9rLXi8BXkSmHhKYyUlsAqDXVwNPJidMlOHIlhwUkJQZy688Yo5KdvM0YrhTbbYRLtqHKZqahOf89usNY01HTzugjUOosaoFs4lhkvCXrwH9seiLK8I5miDUU9PviEiEsgElTZRWnxGIhODr6deLs21bUL/AJJ0FHKlU9tsll5+R4i6OVc9u5YACLWRGUN4cwievvJ4TDFHrOpl3T1XpvagmQekfkVd87zMY+PUQ3n/SrKRJuQoPIUYCtymgyyOHYgEwUTzA0rTyBZib6ITwlMBwYKttPMzMhH3v6y+mZURD/KqT0z/nOs7QvsFxEIKl+I1+VdpBULfVbHWBbpTu6KdbBmgOxvzg7Qll9Z5ndzKTuB1IAMUJ7iGdFSkcPSlMV8SnlgowgUmwHqjQQPhNLq1GIhFOaxs0L8nyhFtoGxVvkVBoSciIYzN7osn0wZP6ltQUF+KGhxoZGrEG3NNEqBL+uBbJfezY3YHQ+8EniCRAnxeCCXCHQZIpc+YdeRrBqD6x4wqVUCcXT/5UR3MpJdhZAUrl9nzj/cqbXmon1M5qTBr+rywTC8W5Jo9qO7/wtLBljDaJKl+bbjJ5+xDNcV0PXK89VN0AfDRdhUDkP2LL3NMzcmJBZ1DXgEg7y4+ox1VG26dCy/Gn9xvH0yh1/nP
 q+fhNuJB
 7IouIgES7zuuwka1otWXJu86i7C7f7LcnaA4uKJwbJPTXEH/oXsUiZmtuG9CEFhopUIMPL99b22WxR+/wiyGvnLiMQCaW+XEX2z5xvPfDt93qx2zDRXey/azolss+PZEY15R6VREIEbFAcnkufIXSC4TGEC4XtviU+W7MOVVUzQetffV/bDmo/c+w0iS975pz/D80F7LQoxDA77Oq+/xd11PMdoDR1qFCeqGqCP3Hg+ZEGmhBVSageBgGgLYjFElvCn0AHexox11X1WzbnfFFsGr/kxZIF8U4ZJemipM+Yc0wsmfekvcdJrBAxLmE9LgA5dF9zx+I26xMfuf091Fe+Dm9sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 11/17/25 2:47 AM, Jonathan Cameron wrote:
> diff --git a/lib/Kconfig b/lib/Kconfig
> index e629449dd2a3..e11136d188ae 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -542,6 +542,10 @@ config MEMREGION
>  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>  	bool
>  
> +config GENERIC_CPU_CACHE_MAINTENANCE
> +	bool
> +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> +
>  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
>  	bool

Architectures and/or platforms select ARCH_HAS_*.

With this change above, it becomes the only entry in
lib/Kconfig that does "select ARCH_HAS_anytning".

so I think this is wrong, back*wards.

-- 
~Randy


