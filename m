Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18930D66B80
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 17:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE5A6B008A; Wed, 17 Dec 2025 12:37:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5E06B008C; Wed, 17 Dec 2025 12:37:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB686B0092; Wed, 17 Dec 2025 12:37:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5012A6B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:37:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F09D4BD12B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:37:52 +0000 (UTC)
X-FDA: 84229670784.04.011E298
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C738C0015
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:37:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765993071; a=rsa-sha256;
	cv=none;
	b=Gxo8CbdZUA69TUJoW1xUIRdJclbZyzLAfJg7WCAzuJD7pxLl17qQ4M1JEXYooNlxsEXR5a
	X44EwOVGhHhoJ3NSfLJZvJ5WuXKmQQK/S5kgap2aTQ5syFx63iHL5bj/U/uCrZxq0BX+b/
	U4ca7WW208Ryw86NxFTcKynnT5AxwVI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765993071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L6hJBK7unhyp+mHlUYEK5OS3YadK4hJIsPBlB04DdLk=;
	b=yzwJnlXZwkq8dO/NzXPejVWw3k9R/8TnnF1QzEK1KHsW9ic0d/lmoe94Fx5KM/qB8gmYHC
	WABnl/Kah0jfrXKGi3Qa+VY4kfCs3nxtlH0lfR1a+iAjfEgjWx78hWKshGh/CskArzkoIL
	SwuWd9AQMZ5hPY+Vhs3fsNDC8iLS7oY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3639FFEC;
	Wed, 17 Dec 2025 09:37:43 -0800 (PST)
Received: from [10.57.47.3] (unknown [10.57.47.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17F9B3F73F;
	Wed, 17 Dec 2025 09:37:48 -0800 (PST)
Message-ID: <7a26c273-ebe1-4b5a-8d6d-1b81cfa80656@arm.com>
Date: Wed, 17 Dec 2025 18:37:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc/mm: export symbols for lazy_mmu_mode KUnit tests
To: Andrew Morton <akpm@linux-foundation.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
 <20251217163812.2633648-1-kevin.brodsky@arm.com>
 <878qf1kqg3.ritesh.list@gmail.com>
 <20251217093036.3231f9613ac8f9cf3943357f@linux-foundation.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20251217093036.3231f9613ac8f9cf3943357f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C738C0015
X-Stat-Signature: 6bi613yoxcmkz6ij9hps311xhdxsyroy
X-HE-Tag: 1765993070-617114
X-HE-Meta: U2FsdGVkX1+5ifNzJLxJv6Vi/aJEDM0ZogIXNE5dkOk4WtJ4eW8vWh7Na2aiBpmz8AbaraCNLuJf2AlasSw+o3WGh6lim4cUPJd6dOF6JsJTAoHatFzw05OMCo5bjgs1KumrhNwDtjfr9RGZ/uHkz5ueG4ax6+yGidSe7Ig9arhpaPODP/ncnlFfDFBJdbtMAqLWke0p/7AtuK4B1EeOIM6RMd6KCYiYD7HQqx452XWg3qbbtg3DX6BofwO8ojsAkgVqcWWlpDik91EQ6ORqzY4z1qHlPasErHx7b/lJqs/nRe19WqMX+VVdUIcA4C3hLm7RITmKihRpdSPp64tNymkQqyTypQQ7Ku9Hadzpw3iE9pbN2+4qRzLSfp9/cB5Ovgxf3FOAq28k10QAMmXlgw+79fgLw8zkYbaPsJ8a2AdtJ8J7ofXxni0C65VHdMMdzjFo3hzB1g70G5PTPQQdzMvIUBRdMI9GtiywA0hJ2pRYR9R+cEaVqNIomCf8uO6CLBid8g5VNebNyTm4E9A7O6lcUiwzBFeEvWYyJtHGRJHQA1N+S1XPTOw6zbrLK1a5kNbmli7uIBILNT5rbMqrWqPZt+EQ6fEFae8FLnNkGptxMOlRG4BjOcK90T17PDvgdDebqBJ0S5A0RdWXkrT8ogYveObGV8KzlKMRXs1IdpjesFq2oUk72hxI1kJX6RpM71j+LbaCPCGwNS0lIGZDul+BQjs2OBDEpAASGsPvFkWKrk8zTW9oJeESH9palBnNyKKzTOFOOBLR2nwsIW3HHs1PcbSTkeCp45dit+WzzxS3uCFk0YUoaJnVmidoMWFFMNnQ/YzIYsHuFEYAA6bOlTWh4HpmE+ANnxGuuZZcj4/3j9BXr9fOTEx8x4L0yzOOU1OzgmRwxZc/RKBSQSMp0gk+I7CKgBkzmvM1UWe95b+92gJLcszpEaSgxBa6OFCXvi1rScYZ/2Lk+FFvnnn
 1nvQknYv
 2pHqgsqgkgcc6k0H+9L0gSOq5ApjyOasA75ucfA338nkX0u0AoclTITuY0GlpDRY7VZqmgky+bE8lwHOTYEaxIjEg5tR4EoCFvii9TNmiDQGwJxPE0jIpQi9ER/0alM/KLaHe3gDKOIWRaB8d42z7Rq5UMWnRYG9ywND7JjYVElDqHC/oSm8peOZBo1fT/cJ3p6zqoIHY8nhJfinmw5KPvCcigSI4Yw02kpxF+TMGzhvB7tp795jGJvxx/LInWCGl3nNGV1pCs2sk8nH2rHvNylEpqTUSnzMGERhAlQgfYUageTMa/Yu9Cj5veA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 18:30, Andrew Morton wrote:
> On Wed, 17 Dec 2025 22:15:16 +0530 Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:
>
>> ../arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL_IF_KUNIT’ [-Werror=implicit-int]
>> ../arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: parameter names (without types) in function declaration [-Werror]
>>   AR      init/built-in.a
>> cc1: all warnings being treated as errors
>> make[6]: *** [../scripts/Makefile.build:287: arch/powerpc/mm/book3s64/hash_tlb.o] Error 1
>> make[5]: *** [../scripts/Makefile.build:556: arch/powerpc/mm/book3s64] Error 2
>>
>>
>> IMO, we will need the following header in hash_tlb.c
>>
>> +#include <kunit/visibility.h>

Ha strange it built fine for me without it... Maybe different config
options.

> Yeah, I already added Ritesh's patch which had this include, so I
> think we're all good now.

Great thanks both!

- Kevin

