Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 838C5CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA64B8E0002; Thu,  4 Sep 2025 07:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DC38E0001; Thu,  4 Sep 2025 07:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA1D8E0002; Thu,  4 Sep 2025 07:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B70618E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:09:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D92BC0125
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:09:11 +0000 (UTC)
X-FDA: 83851296102.19.741E426
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F8EA10001B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:09:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756984149; a=rsa-sha256;
	cv=none;
	b=2byue7wyz9KolVXyaxvcB2VvgsknmG6CSy/YZhvd0Sob4afwP2JXOEa/JLjxoLETEplolK
	39gQHB+bQP7KC5zvlwQiL8xFgsA13DhVvPE9O/T43FB6Z4bN54iBM5DrmVe7C6edypSqcG
	6NXITpWC/KMqNsjU7y8IGm5PtgIUtk8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756984149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oujTjuUbBnzxFvoPRkm5vktMDYZXjKawZfKYSeTKjOg=;
	b=CloG5l+FFLrG8RK86pbFU2gflFQn3w/1x9lD9YmDngYcA1dW8cvsEqskvmqx7CS4bTpU70
	zcsyOSPFQaI+K1LKvpwiwLE4Zc4NRmVWYjfNDq8ksE9XdUGuU0j+Gs35OPd6IhOSjC326w
	H/MOtqxqI6iokKcr2LcnBN0CWXW5a+0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A9691756;
	Thu,  4 Sep 2025 04:09:00 -0700 (PDT)
Received: from [10.1.37.179] (XHFQ2J9959.cambridge.arm.com [10.1.37.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 669B33F6A8;
	Thu,  4 Sep 2025 04:09:06 -0700 (PDT)
Message-ID: <d6e6b96e-1bee-4af0-9343-9fb365beb4b3@arm.com>
Date: Thu, 4 Sep 2025 12:09:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] arm64: mm: support large block mapping when
 rodata=full
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Yang Shi <yang@os.amperecomputing.com>, Ard Biesheuvel <ardb@kernel.org>,
 Dev Jain <dev.jain@arm.com>, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-4-ryan.roberts@arm.com> <aLiTzJ6E-YBIYuGo@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aLiTzJ6E-YBIYuGo@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F8EA10001B
X-Stat-Signature: am7cw5xfskx1qkoh1giikneuny19jdxs
X-Rspam-User: 
X-HE-Tag: 1756984149-3228
X-HE-Meta: U2FsdGVkX19jkxAwRO/44q56aGCr+G2oISOD/sU82ulgLI4mnt9ljDlaI+lPF38gA02Yd2YP1u+aMVbdY6vH4QLprFiGNrTdwKmpT7SXe2S3RJ5Lbx1p0mVDaj1mxxHp2ZLWZf63lNT0hd+fZc94WME4IdhpRbcw5kFE7YpzQ9he7daDKNcIUfL/gqn3q97pPUAoZtqEEx5iABwfa4RhuYMCbkZLkNVAvlUphQVDbDHopwoC9tq+jl44CxbPOEInB8pg7QgAArQvknOXmwGKD0dIfKBf0zPzvhzwjkdhUFqA/Ni8g73QApLgWe5nY8yTCPgabKRla07X/VJpHweEMzAJEKPqhhTjTqDezlwuas2psOz6H+MZGnvvleqxbcdiuiWr2picKguqYGG29K0mGzcPqbi8eAl77+jFCk9wGtJpkErBwdNYIHy3XhN5coNFmf//KzpA9pjYvpql+iZfXM8R7HzMkUS1mqXiBvqqK8PB5ERLDUzzc+2z2bWdWCM60rqy4flQQpAwkiyOhcjZvxv0hEJiYz2zAVXHith3jYaTLYnxwOIMWRBKNZUSFgMk3srahv/pGYQrkxC9ZMFGsglPi4WAN9iwOQBp6NrNunVRqj7kpe1/NwWlj05TR0W6GL8ATkRB2TMAnWOlfnzBeuWbD0X8E3Cnl47Gbl19FSFXGpI3bOcc/RSLBZ30uK4aWwI818KGuS+P1X9xCwcJN3HxNIS7bcejUrz8ppCCOejT5fgWB5q6gWLdZSBrehIn5YMNZw7FZz4bxx3OMamROn2G5+sdfAx5dgKKPnQrqzyV2F7lORLcM1/oDZxa51knDAa6Zhzxesac6Iv9JTbDmoqJhMcLGoIcNT4R6RwNelJfyNHddncGKj2qPE/Fn/Zibg1Nz7Ei0QIycxDHDeGlkwzkWyK5fDKXPlvbNKeOhGRYRnarqiLd/rjX4mQRpdUIMGAdrddW6reo1oIlyU7
 oU5lG10J
 qyBwXVrwY2+zfjd/vFFGs0xTrV5pBy1udXYShlIPID0tzr82ahZJDZzaiwKSk0pWEYwDR7CUfjMozeBKpYVfONGTwTI/YRzMFu+p9dErsSP0iRBVywJWfplR+mTcpkfHzRIquDwegIlxpv5//RZxeYJnIaEnQ20xJsiiz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2025 20:15, Catalin Marinas wrote:
> On Fri, Aug 29, 2025 at 12:52:44PM +0100, Ryan Roberts wrote:
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 34e5d78af076..114b88216b0c 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -481,6 +481,8 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
>>  			     int flags);
>>  #endif
>>  
>> +#define INVALID_PHYS_ADDR	-1
> 
> Nitpick: (-1UL) (or (-1ULL), KVM_PHYS_INVALID is defined as the latter).

Fair. Will fix.

> 
> Otherwise the patch looks fine.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Cheers! But I think we need to solve the issue where code is ignoring the error
code problem that Dev raised before merging this.

