Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42C6EE20A1
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBB26B0005; Fri,  6 Feb 2026 08:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A696B0093; Fri,  6 Feb 2026 08:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BBE6B0096; Fri,  6 Feb 2026 08:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E67886B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:07:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC591888E1
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:07:05 +0000 (UTC)
X-FDA: 84414057210.30.E02F0A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C10851C0010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:07:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pADlDw8M;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770383223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BfMXOyX2VSf5FRxfCLm7LvZCe4n0avyjTdWFz/Mn6I=;
	b=Q8WRbCLNdm5O10GArPAEiZOlmdJsPZUGQUqrOYIHiyn/OziUH7pay/9wrf3feZDr5OVW6Q
	JCT3tz8GxuoPYGkHcGLMTIa0VxLainMkJX3xysV7zVma+BWpsbc85kxhNYxn75GKCMAm8B
	AJ9+jwQpkO97bU5tRSXt/l5xFt9CV3M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pADlDw8M;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770383223; a=rsa-sha256;
	cv=none;
	b=n7Z1iduJRzO5sGuc5J6eHge3TNq7d5nGk0di9wqm6hcii5ePzOeQgyWpRXS3j9GMNYFUc3
	SI1tut9PAq4Bth93OChgyBYR416QzDwKLL84k+tC9Kf4Z4bzW0ExD5LWU3jIQWA0WGxW5T
	rOHpENl8s+N+xP+X2XUQfFH2za1hzIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6AA843D3E;
	Fri,  6 Feb 2026 13:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D59C116C6;
	Fri,  6 Feb 2026 13:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770383222;
	bh=gjqm/xw+EyLKIgvQKuFWku6zxpUiLlZVezFuLgVUV6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pADlDw8M4pf14jpmlIFbIscbYzigwt0Z6gyiUPqPYg4K53sg4tuJNS+Fd8+FfzpvP
	 C4XWlPplSyj14cXa9UOyziF1zOax7eidmDcttDSh0mjeh/D67t8YdTHpquiybuI+/P
	 Q4NABcm2YikcvBj0ZVFXg/MYMud+oq8IN8rNdASMAhRBY4xV+KoolGf9pk+V097FMg
	 EzBd1mN7Vu1V6bMDFMIYJvXLnz1586zJu9OcgL9MTm+6kLK7kQUrdnyfLgd8ZL3Otd
	 XR/MPyTP6VxLKOchVZSl3jixlqmRd+7Uiwdp721hNeoHeewXT7Xoj99I5dJSjBTylf
	 cH5uYZEzgAv6w==
Message-ID: <75a6bc37-e597-46f0-adf8-c8ec8e5e0e4e@kernel.org>
Date: Fri, 6 Feb 2026 14:06:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/13] Remove device private pages from physical
 address space
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au
References: <20260130111050.53670-1-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: painur44obhr3s4w7nstbg3qoxu1h667
X-Rspam-User: 
X-Rspamd-Queue-Id: C10851C0010
X-HE-Tag: 1770383223-512005
X-HE-Meta: U2FsdGVkX1/dwrahlfAeu3fCDeCuJEy5uJ8UElfie9Hf2bndiQSyxxhNYqE/UWs2gJARk/7A6OyooiWYvjuYri8eluYUAcOL58B2rjFTOXKSuj/JJsL15+HnkUwoPuTw+9BFx45674yY2wblnzvgjnUn+tktItaz2FjqPOd4cAY3tgtX1WbzEoDpdd5e2YfuUIxmr1//co7ZjPyn6gcGnQ7wQRsZVngClDuy8kQ4BLpd58iLgpjNhyZgftGTA0Zun2rSOl/A6EALaUnNA5nV3YvwAZ49PTdoso8S1CArcZPAfhDql7FyU3DKXICv2N/os2YUicK6YnUgscoM/ZXHOPo6Y7YDjvkR/M5Rfmc6bFaTKwCp2ZRu0E/CNtQgO+T62Cu6mV0d75EuKHTVfMuaKKxJ00K0KyDP/giL/a876DjvwMYqgXafc0XvG5Vq1YJ/Wetoi3hGcOP2Nr/T3oJvPQK+sid4CVRXfvIaErliN+O6c333RHd/JWlLcKmXUByQbS3rHRcYCFPk4LT2GSEMePfFINsZ5UfNHPPcLsInFjmySq3J96BNgO23zcuDl7ISpruLOaN1TWnZPHToHKZUycpfVq7QxSrI1mmAx+H048H/zwiB3mSJm1uD/f7KaNsvViXjf6EIQVo14QS3jdUrf0UDUV8OOhAo53DO24d1ySOyJYGZwbMQ33HHRK7GBkdgNY0yBVEqV0be8vVPh06qGQjuiVj5EooZjBNdsx/KhpSwHp/DtMKD2CcPq+eP4mLPfNYTMomwOe6UJZSbQjZaCILo1q3inuQfmrVYeh1WLgzuNBxC9LHjSbNsSJKseCGIidXds5NvMH808VH63an7Ht3t8x30QeC7CBGTmeRy4Vl9T2pofo3btpP/4Dj8uQNDahoiR2qpvMKc4lQhIs7+iuNQ4IlpUzR8uOfEi/hRV02tpM0FuUu3FM1le3mb3owgr1CbsmUz3lw98A5FnEw
 SbGDCvob
 iJ2UdQrweQwwAqVeqg1MFluERQRTlnrDBNK9O46ZoHjf7DBf0A04Fe/YJVZd/Y6Noo6mPDPC+7YtCgZ8Ci0pq5NSP6KO17AqBmM7+1DjlsjAkavbVFh/U6VdN4hSnjf9zttxxIMxTYJytXPOFy8FaGJSpnmXGKRQX8S/gTpAcnflgSadNxbB3GMLHqS4PUZ8Fpxh7NuXFV3KJ1PR3iiHq2aIz92AwK7/P2vPjGvwbnP4MyhpPRbT6WiEtcK3LAmEOlAy2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The last patch contains the bulk of the work where we change how we
> convert between device private pages to device private offsets and then
> use a new interface for allocating device private pages without the need
> for reserving physical address space.
> 
> By removing the device private pages from the physical address space,
> this series also opens up the possibility to moving away from tracking
> device private memory using struct pages in the future. This is
> desirable as on systems with large amounts of memory these device
> private struct pages use a signifiant amount of memory and take a
> significant amount of time to initialize.

I plan to take a look at some things in here soon; still catching up on 
my overflowing inbox.

-- 
Cheers,

David

