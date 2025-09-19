Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C062FCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB0E8E0030; Fri, 19 Sep 2025 06:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2C58E0008; Fri, 19 Sep 2025 06:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8258E0030; Fri, 19 Sep 2025 06:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C82428E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:08:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F50DBA529
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:08:54 +0000 (UTC)
X-FDA: 83905576188.26.57A6003
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6945A120009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:08:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758276532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kkHrMEWTroi5XQ5UGglMftMck4qCYCQpPf4gqWIwhrE=;
	b=2jTljV/QeYRAwmu4IpualaMWi7RJJo2kdWn2IPZsVbpwNv+deKFEYOeLNtS3izNOo2BvHm
	z0Dsomwd8CsT3qHljNySpYtm0Jw9lMu+jFAoC/a0dLHR0w17VwqM1RNqL3peBlDf5bQQJL
	5gJMNRN8ddqL7aGyDNUaHOUQhZleH2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758276533; a=rsa-sha256;
	cv=none;
	b=kPC8RCzXnT57hCavOW9DkQBkHnKFv68IAog/7PXMBKoe0G7VkVDcVvaTfhloXvkbEti3pd
	nmK20oT4ipppDttH1bPq4gfo4zKYYqaGZCWX+ECyPc6iGqqC87jGGkdzbUYCBy4LbLZ6tA
	HyCRB67ldK1SxCAT0mSmZaVbVpAKsUs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20E6D1692;
	Fri, 19 Sep 2025 03:08:43 -0700 (PDT)
Received: from [10.57.95.38] (unknown [10.57.95.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D058D3F673;
	Fri, 19 Sep 2025 03:08:48 -0700 (PDT)
Message-ID: <fc43aa07-d4ad-47d5-8381-61d4a9b8c467@arm.com>
Date: Fri, 19 Sep 2025 11:08:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Will Deacon <will@kernel.org>, catalin.marinas@arm.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ardb@kernel.org, dev.jain@arm.com, scott@os.amperecomputing.com,
 cl@gentwo.org, Yang Shi <yang@os.amperecomputing.com>
Cc: kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6945A120009
X-Stat-Signature: 4w3egmg7ortpi1h1bo7tx1ktnxd9b779
X-Rspam-User: 
X-HE-Tag: 1758276532-155405
X-HE-Meta: U2FsdGVkX1+qfnWRW1GHxZ1y9OAkFjVcNmVagLYv+i4ML2gOl1+ILe2nrq+LFAdmgLlASazLHBQYWlPOf+DALA8akU/GxQ4VL4ytw+yiIbnXbzclJGSrkcjgHFz8Iqh5JJQ+sv4rZ7BIZIz52gS6OU7Er8uUC1IEOVYxqpUnpJe7mmWt4IZpFvQ2tcCh/pao4VcRx7TFq3G0EMJnJlA52KvZoPavP1IyMC+uv9IQQauDB8IVxtyIn4hR6IJZIrgZFdT3NB02/gIYh3gPXogDpJHJXKObw/7aNvokudHKhsaSG9Etv1SlPrHSZT1SAvV5ErG82Ms1rfEanmlf+FC3y6OzHimLzRKCh/fvXIw9GAu0Un9TNDFNfo2H2W74Fyu9yr8d2eIWU6z6wAduEXvRgiYT+jckhZtbtGwfFtqmccp1vJSlFqdq4f+PUxbtKR5QtFR5B208v/GGV5lqKhtAwIkd3B78ho+rdqPhfouvcKjy9PijOXJ7vG9OEP9wTZXMVkwYENj0AVxOwGb4XXzzYU61GntLw4FkIGpotQ3LXBkQnWJv+sQ1FjTrmUqLV/qzNvNsRrvZgR6Drbi9Z5qHJ2SzSZPwoFkQGTGY4mPu4wo7aQxD2lrk/tkJD6l3ECn6iyPHVUbcHyQGmaot/d57VP8HIBjW6MgZYYuPyj/rrGJuqQV0NNJcD36m/s4tattd0BepwjL/k1DEk6/6MWM4k6E0xhP7Xb6apunIINSXhrmMR0e81YS7mTT8WnmE63VdINAM+8L1QBhtISIMT6VWO8ajt0a4oO7chqXGBiwYac7K+sh9d95YznkFMdYvyVWAzvo83rCH4fc/Zxj5jMvTgFvKr8at32Vs49rJo3ZCHUKlquYaNua2hoZx3EIs2yifjSKCRrjGNOhmdlGS5tKJIQbHNZLesAFQEtRdqTZ/GV3Np/cZ/pJ6o41T9zGoaC9xTYSi6bwy+ZJmurT1kjx
 R6R/cnG9
 VVGhsG0MBxc4VWsaYJIBR9UFa4FULWvF7EI5RICIn4tc4/Hj0dLpviLAsRuKECdXPEM4Hg2oMomMi2n8hGAzasS9HtX0Wcr9LBo/VePUcSu8lQESS/loyrNY9YwzKVcJFxZ6NbkUBo2vwsJ5ngopmj0pLfr4TH/ih5aOjkDKktRRuFA4fIEO8RXcmPmXXjVhod/QxIJeSgeoUslBcO6gqy0QaAyPlAFtdMtH6rYo1HB+H1pwml01EvRRf3F9pn8lnJW/Ky+2EDUJkhy64LNAYZlBJoTJUt7jIxzcrtHaufFENFdtHxLVsc93MhnzDDrWCwNQU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2025 22:10, Will Deacon wrote:
> On Wed, 17 Sep 2025 12:02:06 -0700, Yang Shi wrote:
>> On systems with BBML2_NOABORT support, it causes the linear map to be mapped
>> with large blocks, even when rodata=full, and leads to some nice performance
>> improvements.
>>
>> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
>> modes by hacking the BBML2 feature detection code:
>>
>> [...]
> 
> Applied patches 1 and 3 to arm64 (for-next/mm), thanks!
> 
> [1/5] arm64: Enable permission change on arm64 kernel block mappings
>       https://git.kernel.org/arm64/c/a660194dd101
> [3/5] arm64: mm: support large block mapping when rodata=full
>       https://git.kernel.org/arm64/c/a166563e7ec3
> 
> I also picked up the BBML allow-list addition (second patch) on
> for-next/cpufeature.
> 
> The fourth patch ("arm64: mm: split linear mapping if BBML2 unsupported
> on secondary CPUs") has some really horrible conflicts. These are partly
> due to some of the type cleanups on for-next/mm but I think mainly due
> to Kevin's kpti rework that landed after -rc1.

Thanks Will, although I'm nervous that without this patch, some platforms might
not boot; Wikipedia tells me that there are some Google, Mediatek and Qualcomm
SoCs that pair X4 CPUs (which is on the BBML2_NOABORT allow list) with A720
and/or A520 (which are not). See previous mail at [1].

I'd be happy to rebase it if you can let me know the prefered base SHA/tree?

[1]
https://lore.kernel.org/linux-arm-kernel/11f84d00-8c76-402d-bbad-014a3542992f@arm.com/

Thanks,
Ryan


> 
> So I think the best bet might be to leave that one for next time, if
> that's ok?
> 
> Cheers,


