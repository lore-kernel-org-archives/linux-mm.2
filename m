Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BD5C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41076B00D1; Mon, 21 Sep 2026 05:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CAB36B00E6; Mon, 21 Sep 2026 05:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908616B00E7; Mon, 21 Sep 2026 05:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76B8F6B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:44:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B4AD1A060C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:48 +0000 (UTC)
X-FDA: 85237285056.30.81B8836
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 17A8C40004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e52ERe3N;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEp4LYwMgTfVPMINLf7e3EcoHtFv/mY40evw0D6GOQI=;
	b=DSR1qT1HeWCUXQQWK7QPKWUkAGVXTaZ4VJXmZRJEm2v3aUkJgN06Vr+p0RriMqFCuHfWQN
	IrwnfJnbCSUCltlgSVRvaDVs2R1CQAA3GR1y1njqWFakg3opeAEf8plQTWk+DMbAQz3mGE
	D2yrnc0sXfgj0y6CR9O2gNwBmZfMJA8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e52ERe3N;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789983886;
	b=EEK2JzVLmZYSipC1yL+Z60apBu4vzcL8oqzCBTYNlFXgFQuCCTNjy5gLwzkvpjd5FyXuH7
	DEodZHfCTkclv7SZalyOy/Y9sCwiPo9KSSgeq33YDOkPDPowtrzFx+LRNAU38fudr7GU+S
	Rz8UUXlLerbyMqjBdfFxxGDfj+Gfgt8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84ADA153B;
	Mon, 21 Sep 2026 02:44:41 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1793F86F;
	Mon, 21 Sep 2026 02:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789983885; bh=21HQ9Jm+j3bA+jZJyxERUm/iQSi9IvRUOjPhb/LBexA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e52ERe3NX85DTf+sp8aD7+t+Z3+kuFmz2m3Q1UFRyMS1D4lxPKCftTkfNT25qwagy
	 O4kzIm9OdRUieaMkJo7t5izcU6xr9HIDIhIJ2AIjuMfNbPHeo3gS24WWx3cczAEWEL
	 Sy6+/Iq7UIvFNwm5CwTWVVvAgQg4fN+pILUIHuRM=
Message-ID: <cb0f1d49-865b-4728-89f7-7d8552dabd67@arm.com>
Date: Mon, 21 Sep 2026 10:44:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] arm64: enable a distinct type for HW PTEs
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-6-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-6-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: uxxikejc879hdy3sj9iagmgruwbz8nu4
X-Rspamd-Queue-Id: 17A8C40004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789983885-519992
X-HE-Meta: U2FsdGVkX1+hR54cLIqUCwcXriURgFWDwho5B0vRa3kPKrG/jN8Ik1tTgOMf1djjfg6+DesZGNMig/tyj8KuKLv4GaMxyI1Yq5uriy0cxzX7jVjOJus44Ky+kWBlTeHR1lPk7ee7MPpl3QTbxN8sLmmWR1X9xTloXCfrH6ctap4OYb8xqwKLwoaV8YioVHkuJq68v0kM8mEevuarci8QENG2KJZw7EauaocFoXmcK4tCxH/c9qvBnX5jx4QF1I+Hs1qwIump4WPPBwtWfWvnm8n+PYw2f8MfjTHqfEbfV+kz88QOobqhsKWy7vfO5tS8P0r/N5RioF7pSq66LjsnbSbkmIgpipYavmHbkKDc21/I0ZC3bwth66P0ZF+dSsWvllgymNqpe+JjtJl/IVZBicZuP5myhGd0tZnN5hy4H3/na8YtwTiKm0+4nxe+lSbj7cfnU0jGFm9ScdcLIcZDvexv6ANTZ9hkUOw4JrYHzlvfo6wF7RaVU2RikDWyAFZlIq7eSptT7V9LA6F69mkiGG97maASKyIRm7WbvMfv/CHXfyA6xVHqRzc+MZQCJi90cqh5IJCeeaLM8WTRs7ljdvvZQavnKKvojayWeHOxkP+s1PiohrZxY2jL0w1EpL1TyVJtdibzW1sGI3ZG8R4RCNl2rMUkcvGc/iFq3oDK4mVG1HrhBAhfMlS5dfqJDNV7SMWFjN9+B4WWhTXydc9lqrXmicSBt8rZYWWp6tgLPG2o9sVMq4r4LbbYa+Qs/pk1N5wR/Vzl+5ZQpWAHgeUM1PAnDQBJfWXI1FzON1ei6O+btLLRMPwAxkPknehBU3VjsfVPWYjFrOKKvVarts5KZuu2gAxcGND21DoYI0aQu/CZ1R7i8moTYLZEUUbYClqkBMNxupE0EbA/GgmEGkfNz7/Hdes/dw6FAAkUywrK8YJFyNC+VCZMZxoT+9in4SljAHHSO3wVDqZkZwCpFjw
 S7LPsipJ
 Yi8kOedYsCK5tRc+uvTQ0dqmyVgUAkjAouTYeFfJrYJfTC2yWUAAM4hcz0q6aJbNkR3SwkrFuQylqWSwwsRnbX1WF2paOMuazvcn2g2on7+yC9G2FsySvVpbQYWcOPC4XW2IUhOtfjSRfhYnabjaUAr32JwVujxlcImhYKEcuHpLIDXKbtf/XSQ7CR6XQfb/41YyGh+1Nx3NKo+RMMEJpzOWG/y7g+DkKUQuauZjZ2fY3C/R9Ie/adXTEtnnY08fkCOWtufiTPE99VwXs+FeMDPs+NdgtHw4dhFu8a2jy6crR1hYYiCO39ehzYHWuFvu16t1KSfoew00C3WiJMcGKVNFZ7XfWqtYkGHrWDzsX9UNM2ua0XTlarrwSsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> With HW PTE pointers and direct HW PTE accesses converted, arm64 can use
> the generic hw_pte_t wrapper instead of the pte_t alias.
> 
> Select ARCH_HAS_HW_PTE_T to give HW PTEs and SW PTE values distinct C
> types.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 2bbeded33da0d..42841d5e2ed26 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -31,6 +31,7 @@ config ARM64
>  	select ARCH_HAS_FORTIFY_SOURCE
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>  	select ARCH_HAS_GIGANTIC_PAGE
> +	select ARCH_HAS_HW_PTE_T
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
>  	select ARCH_HAS_KEEPINITRD
> 


