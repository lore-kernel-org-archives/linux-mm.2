Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1BED46952
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EBF6B02DF; Thu, 22 Jan 2026 12:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E68F6B02E0; Thu, 22 Jan 2026 12:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213316B02E1; Thu, 22 Jan 2026 12:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8A76B02DF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:43:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB57413B032
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:43:15 +0000 (UTC)
X-FDA: 84360321150.19.B0F4027
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 92E9C40008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:43:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769103792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IC1nmLBtm4Umuesd0ATdVbgoTnWRyUO5sVgMVU9FtY=;
	b=LYq7AFgpEAqRO0Ms5iHwwndN86lOMCWE2XH+NxXPjcE3r1NzVzftrp5hRZ9OEH/ITXEPL8
	WTUiUGIjuXKc9HsJ1IVtWeYY5Xk8Ed+pUoFrsix7i9zMAlgo58ZeKhTi9kiKs8iULPr6B3
	RVsllSmZSHHwZdogefdk58TMYZSQWNA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769103792; a=rsa-sha256;
	cv=none;
	b=zlqoNf5YGaIe3NubEm+9TUdM6fMTf+ZI/fRd6fdrXWLuJNMfA3TGytRp7YKHlU+OnrQM/e
	eCCyw50+bfUaCjV8X2bANbJf5GMybbnBs0gxz4Qb5ZjszgOPSqZ+oqO2pEIn4/16d2rZC9
	vG46lHPjc6P4w6hyWrBjVnbmPEXBDfs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39CAA1476;
	Thu, 22 Jan 2026 09:43:05 -0800 (PST)
Received: from [10.1.194.63] (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DE1C3F632;
	Thu, 22 Jan 2026 09:43:10 -0800 (PST)
Message-ID: <189f12fb-a558-41aa-9194-19053c6b350b@arm.com>
Date: Thu, 22 Jan 2026 17:43:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v3 7/9] selftests/mm: fix faulting-in code in
 pagemap_ioctl test
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-8-kevin.brodsky@arm.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260122170224.4056513-8-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 4um48nnjiidqu4dudxkgwhe7awefbgie
X-Rspamd-Queue-Id: 92E9C40008
X-Rspam-User: 
X-HE-Tag: 1769103792-458368
X-HE-Meta: U2FsdGVkX1/IgDhpSOzEJHoYJRPyznrUy09a+p4qO+BnILD+CVqETe8P4Gz0FTbX0fEkLJPCmPOaJABzMdeMUYn3vOGyyC8zDFwWoYiBzr9/oHTzddjPqTVV2rsMAqLNWLVIB+nWE+gGctjMPtORotRcdwZP6ohobplzOcrpXfH/LBWMtEA4qFiO/PcRTL231RvP9QAJjPIMYTJKvv9Kvoe/WzS0/seRVqU/1iCL2v8EU7qVILB1pGTmMNZulEfP6OyWJnUwJdAM/R9xtRl2QxAkpf1gqnZD7E+UZ7I56yIbcAo12khvdd1n6GEyzpWmnkZs4yjLfqnmD+a/sPdP0ip8/AYzGkJlDJLRjbrr2Ddase/5sZ4EDdnhXx6kM32k90bAF+NvpMXKAeY+2468MXRN4EVljcRXVoUSj1ToeTO8o2mol2N8jsubiY6wDYggO0KF80gm9rtJ/Gbc2/at/jjiI4DsdXwd4O1pNT7wEcTi0eolt7/U1cXf0sJlsMK07KH7rBux7zrR7pP6ilytQBx++BU4w+pF4N+ugfXG+0n+z/hSy2hkv/BYDbSacb9HaQE/YdvZm5X4MZOMeSHIbnXzQyrIVkfhoeG+uO5IdYGuX4qAkS4egkLN2rGsxtwc/iogwxFDVJn0YUTHDVi6OCyHSRPV05p+i8aA3yHau09uNmyNK/LMJ0G4jcJC5dnydQd3bIl+jMLxV1JPHOdB61QizVTxpNprpKtDsLXdOFqU3d9SnpJgFSKhN0vtPVawZ0i2j1KZyXKYtvDu3uHNo/yKzafnsxTXNhlCwwt24liuj2KhwgJXrF52EoXnFewWWZqBPwAK5RkSOT5sdGVERUW5bX6KboVnFh0fkYfnAXJrEHxzXbOGsQy2XvQl9eTqV4Ycdbn0hEzxoE7uCOqC2ierrVVsI6OJTt/rp9Sfcfik7KDIReOty/Mn3zkb8XRxgBODaXamnKt33Af3D2X
 ZOGbwix6
 k5RTPfrHvwc9zE034mfh4Ny5vohBna0x3JYIWbLJt9pjAYEDT0I9inc8FnDVoHHPXZKEcCQ+/l27StmmbhXhpek/1vg443Ri2P5Ur7yZrIs8tKAMhun77fYbKUXG2rkFi4XlsJ2NOYKcCdqPPgb90145kYVdS0qdY2N4lfOrIFzMk9s7mlhmzfeP+nV3ml+npiUOaJySPO6Z3rlkxdPu0Bk1O/uZuBFBYkQa8ur4wBDgpQmMFQlXj/tj5p9ohQjHUSEZOjLTmHGoTpeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/01/2026 5:02 pm, Kevin Brodsky wrote:
> One of the pagemap_ioctl tests attempts to fault in pages by
> memcpy()'ing them to an unused buffer. This probably worked
> originally, but since commit 46036188ea1f ("selftests/mm: build with
> -O2") the compiler is free to optimise away that unused buffer and
> the memcpy() with it. As a result there might not be any resident
> page in the mapping and the test may fail.
> 
> We don't need to copy all that memory anyway. Just fault in every
> page.
> 
> While at it also make sure to compute the number of pages once using
> simple integer arithmetic instead of ceilf() and implicit
> conversions.
> 
> Fixes: 46036188ea1f ("selftests/mm: build with -O2")
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>



