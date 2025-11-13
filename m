Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FFECD5BA0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 09:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831258E000B; Thu, 13 Nov 2025 04:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0938E0007; Thu, 13 Nov 2025 04:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF7C8E000B; Thu, 13 Nov 2025 04:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 504DC8E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:04:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F38AD1608C6
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:04:51 +0000 (UTC)
X-FDA: 84104998782.20.5627AED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3B2C7100019
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:04:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cmvv58qq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763024690; a=rsa-sha256;
	cv=none;
	b=5ACZahSo9Q2Kr7dbROIJPqavcZl/iWHUMb4lMPYO3anYS9t/E8gOIiW5D+GtpTd6dlTTnB
	OYHg+tHvmV0ZLMSIX+2gXNZwTMV6MAQPkLut0yUiEcEYcMJaxoYOkGJAYpPM+dmTmiJmTe
	b3OQOB9DFgLFtKdSVbW1h0VZqgr3aFI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cmvv58qq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763024690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkpOCPoBnoxbPm/dHfe1tXIDImknpNkGj0HDeligwvE=;
	b=Lsm7H+BTpqMjXOsvMniO5TYI63zMf6rSJPnDJP5M/xwcp6NjXU/GxkjbDztpPZcymNfdI0
	URzCAQaMkOPyCm1Ta7PopSM6cEN2q5NkULZRKjK+kIuxRUm7SYELdaCZvcO1M5CgjY2coW
	CqlRIlYMCSo6gR8PMHFDmR3pQNLCMm0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09A6041E58;
	Thu, 13 Nov 2025 09:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C15DC4CEFB;
	Thu, 13 Nov 2025 09:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763024688;
	bh=g2ApyTbvFn+O4SPpXvNk6aXSXJ9xS0/6+BQ/w0ijal0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cmvv58qqtEpaPmX3c+SScMrcSzaga0Px1RP5KQeXSey4+8xsMlLqfGCnhbrKKZW/7
	 1x1IZ5xh793XC0Qc6GHi023xk+rgYW18Lr0xRCEBskq9ppRl11XNfacbYg18/w3gFp
	 07YVZ1tcjj6/ehzVskFNjBsUZu82L7XE4m3p3DBARMCShxXawh7Z0cBzj7YN0zDcv9
	 Bs+OsfW8jBuu2hv6YWt6955Q+Fs5eIUKQu0ykTlRVZno4XKwbXRJNuKGVGz7tl4FIG
	 u1+Wc4NMhVn96vKl45u/9MW2eIjXsajCrvLfmQ1fBWAuBhqprSdMtCwp4TOaNaDvto
	 4iQF6JIsdz51g==
Message-ID: <a786cb49-43f6-408e-af32-f05dabff36f5@kernel.org>
Date: Thu, 13 Nov 2025 10:04:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm/huge_memory] adfb6609c6: xfstests.xfs.050.fail
To: kernel test robot <oliver.sang@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lance Yang
 <lance.yang@linux.dev>, Beleswar Padhi <b-padhi@ti.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 Aishwarya TCV <aishwarya.tcv@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, Jan Polensky <japo@linux.ibm.com>
References: <202511131537.1a31ee77-lkp@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <202511131537.1a31ee77-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B2C7100019
X-Stat-Signature: zrpju7jjxc4mz6azja9y9qi9mwidqrgg
X-Rspam-User: 
X-HE-Tag: 1763024690-626477
X-HE-Meta: U2FsdGVkX1/POibD8q9T7geAQ+b6dg4P0KxBIOw+wtD3tjkQAuXzvwLmBngEs7Ut7RP+g4YhGIb4N8sgUEq0jSMi4xRWlQ3cmiQ0+LqfMZ9QfNUG5OH/ICV5Gmlx+2nr0Ego+y3aVv3yW1wwM9eaA5u5nsPOpf1m90Qy1gMddSXdczn+u7dsR6WMECtXDMwdYFxuFhDD4DJLquykP1dnI+UQWspp62oKw/2BoYNS62pXbrRHaa8tlIaXNtliv/2XwddBi/Th1ZLNdF3d4yed9Sws4/9mZfR+msVh2rmbqbEofORk4oyuWSQsupYxUEmd/qWN5X/94HvZIaEdIFzVLT1MJQAYXNXw5lKHEaN56Qja4ez3cKJjUzEWOwNCAOhGLds5B9UMTWfUf+Vpf/dr4g0JGj5vDT+EcbZxRzO0i2ZVRSbSKKUKrqnJe2fbTZ5kv/gDt6DmQlWB51UocRght8UMgwlQ8sczP6kqBzdjKLn2/E6Nd0I6z7r4LOU//26FskoC0uEvbB4sjkEDE/hDE4SbTDpwPkrM+ybDRBg6clhGFnDpC7qRLucfvHyhhdTE9qqSsSK4h0qVLUdX1fYCaXD8fjXzzw2cfS5udVxLrI72V3gga+IKRQT3K2v037oyDWn4vPUm60jC1t1Z3vRBDU4rb/BZhc4ure1tfuh2Dm/6Ae2u6hKp9KnOUFtw5hIqJhxOfYQJD8idBUmvGWKwEvNU3g0qYFrA5MSXvumOTO+Q7hM3fXspWnPo2tVmRGwRclUV5ksZCYgYGSLV72N28g1ck3nQlPGSkvSFKsw3zPqjyJUJKNAJbdaDSDZJbiEvfb/ffyogOXx1JLBnv/3I9DoyBuVnD5M2JfvozLLt6ly8ih6io73ceNXQ5kow3hPkE4CF7SsOILEaWQ5hzVnST3+XcloRB+flb7JABFw99VO4PSHt6jFFWxeV0eeAJ2JwT357/a1fwxu05HkUFK6
 hn334oDw
 Z+T8oDdjYb9VJZZT+XEwnQivAu75O2O52wuEfwLAcC9RUFzsGTmQRPcK3DXQdzzExTNZXgidsu2QHV0OZtKuvOMQHGOWRDl0L1/y/3SO8VQmqw60DJHOVGUpRO9zWlTObq8cAFGVHlQFn6UBJfycURO9m6LrqritJ7edUqEJ5NWInJ9e1B38jE/rwvAqa2gayq/+jzXlC0UULlk/8TeDXIlwzZNp3g67w5qafif2eaHKnzyjGkrglPswQCvYKh6IzaS92Vf+2uc8/4h0O6/kjlI+iGdIgjqBElESG3C65Gvsc3yDXnSniFsJvdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 09:23, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "xfstests.xfs.050.fail" on:
> 
> commit: adfb6609c6809e107ded9a1cd46f519c882e64ea ("mm/huge_memory: initialise the tags of the huge zero folio")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [test failed on      linus/master 24172e0d79900908cf5ebf366600616d29c9b417]
> [test failed on linux-next/master 2666975a8905776d306bee01c5d98a0395bda1c9]

Fix is in the works, discussed here:

https://lkml.kernel.org/r/20251108191948.684586-1-japo@linux.ibm.com

-- 
Cheers

David

