Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FFFCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 04:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CC28E000E; Tue,  7 Oct 2025 00:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5C28E000C; Tue,  7 Oct 2025 00:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4A28E000E; Tue,  7 Oct 2025 00:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12B178E000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:23:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9758613BB6E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:23:44 +0000 (UTC)
X-FDA: 83970024768.07.BE583DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE2D5180005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:23:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759811023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXYeCF92ICmHH22nRMeSjQhYMlz8f3pTLSuFwyuGjbE=;
	b=Cl44J6j4GeUxjde4mTwWl5r3pSenYDm7YHXpXapQ3yCRsnp6yxu0DBRVVCoJi0VsrFhkNS
	88yOgoAlAZpXTyRpl7Rgh48uJ4fVvvnJCu8mAxrhLJWRCeKJ/cf/gFePJgfIegns7W6OU1
	BXIpynvlOtd887FciWxK8uYM7ALgEtE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759811023; a=rsa-sha256;
	cv=none;
	b=6U+SRfSfxie2NefhRnohOIBJNSFJpMdMFRacAysE1JCmtpsT+PsngvHHvK2Ivkbn3yCjtw
	kQiCLWdR++7ks5AkiJCloIvD5uyYo4OJYDHumEm+wd+r6q9OK5Ggz2aitvfiJnK1UY43m3
	DvUILgSiUZxyMB2cVm9wpe63zAU9rmc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3549614BF;
	Mon,  6 Oct 2025 21:23:34 -0700 (PDT)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A99393F59E;
	Mon,  6 Oct 2025 21:23:40 -0700 (PDT)
Message-ID: <78c79b17-6827-4679-aaef-4633eada9043@arm.com>
Date: Tue, 7 Oct 2025 09:53:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] (no cover subject)
To: pratyush.brahma@oss.qualcomm.com,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE2D5180005
X-Stat-Signature: zfcdangqpyzk3jr9c1dpifm4th95onpb
X-Rspam-User: 
X-HE-Tag: 1759811022-759942
X-HE-Meta: U2FsdGVkX1/p0tR2tyfxmRAE6uPobyEj0dk67wxg8/bldJ6aFNB52n0cU2SPpbrywltZDoFNYjWgvVfIR37dxwU4mx7JsGJzVCMg0ejm0Gug/hD00GsGBh2XJbSm6F/WAU3/KldXKDg6B2dg94x7LWfVJRq2I/eYyOniEkOKHuDSc8eyS/4Lvw7WIZn17DNvMK8mhY4jJyI2nMbJnWqdYB/M3f96w5j8NiQ9huUuGBZ4nfUn/LH6NjEszY1023mLFIainnc1XqipaTYyPfPeBiVFUsYCbyKEgNPuYNoBiD+XAP+72224y7C/NssQZvvMZcpXgZ7w9EXZy+JND7DLfLAYymNvvqUjrmPxEocm3obUbwAHh5l6qsQL+NWnzj48dTiO5r8qjZMR+1EUl9vc/Npv5xxznS0aBsw6oqeleo6jIRAyPCpKQiOSP+1QRhcgjeKrbh5qV/S+BMq7m4rZLeHxkT4YSs4mDgQ3t8k+4yWBovZN0DFmYk7JOgtYW3hHoXXD8yOEI/5N4nSH+pVs1OoM+4OE9Z9OJ2IbzQtLCPYCTI1mMWaYh/gevvSkuYLikbR5+XljsMA+yHSZnUWSC6VrLVZqGjNuolO9w0MX/klqE3pqIK55uhevAAGJKlMegYeKDJ29U6y8H4m78KjYeb22b6oB6y3CdfCu0zm4MufZRugKuDhNtwTOgs5ileIQCav3fRmniZU6aoXZc21PJmMrz20ytj2Q6FYLSsjpXVn5JgUdZyVOEjlel1lfLMjWuv1tJNVPOoBv+UnUGifirhDdAcDsf/jZzeilWkBQqn9RD7vby5PWbKvd/LEViZs6LRcQKtHvh28VM0Y0WiOO1irq5H/HZ8WqI8046u3fiGG+o4ERT3V1r10iSrRP5G5kMA/bCRHKVkRsX1He+dqqJOAEgxdEGnO8yWY+1iTeMtbfC/ZDwNYwiLHXxrZS3uPdIsHSE+Y9iKuztYMAKys
 /Hcid8CL
 MjMblxCgZgp3GZcW2oLiSyLGlqu1tXBM/nkpzQwGRnNBixit/sdS4KPrKiDBuGYO8DDlO4h1oDgZWBDGGdZD6lL/aaahvtmo4jeTyctrNPNbtprSE4VV7IYsiHq7QIvrgre0Exu4WGh3J7yo+vji4WZAgwNmsRFTfDTTT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/25 4:04 PM, pratyush.brahma@oss.qualcomm.com wrote:
> mm/numa_emulation: Code refactoring to improve modularity and
> readability

This should have been the cover letter subject line.
> 
> This series intends to improve the code readability by using
> existing macros instead of hardcoded values for size and improves
> the modularity by moving the size calculation for emulated blocks
> to a separate function.
> 
> Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

In general, a signed of statement is not required for the cover letter.
> ---
> Pratyush Brahma (2):
>       mm/numa_emulation: Refactor NUMA emulation size handling to use kernel macros
>       mm/numa_emulation: Move the size calculation in split_nodes_interleave() to a separate function
> 
>  mm/numa_emulation.c | 47 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 17 deletions(-)
> ---
> base-commit: 4ff71af020ae59ae2d83b174646fc2ad9fcd4dc4
> change-id: 20250926-numa-emu-6e6c27bd8f6f
> 
> Best regards,
> --  
> Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Ditto.

Seems like portions of this cover letter has been all jumbled up.

