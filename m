Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371E1EA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 13:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1F46B0088; Thu,  9 Apr 2026 09:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3526C6B008A; Thu,  9 Apr 2026 09:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268596B008C; Thu,  9 Apr 2026 09:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 179BE6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:04:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81C0A8C3E7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:04:30 +0000 (UTC)
X-FDA: 84639036300.28.803E3CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 38D7040017
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:04:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WEWHru9M;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775739868; a=rsa-sha256;
	cv=none;
	b=aDSANrzBZaQnuhepxSavgq/pC02dgIFpxNsQ01I/7+CR4cE7jLQ7xldLhEVxekd0AF20hz
	nHh1XemRaztJS0ZnFTaqaFeRH1TAWaOQFoJ6fs+R23U1tdk5/onuVYtFUOZTdjU//lHG02
	4fW7e+yRSUdz1aWvsPgH/YItfl39MOk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WEWHru9M;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775739868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CxLVmExVUDvo4D0kgtu+lUbRHYuuHvCMXcx/stGmLA=;
	b=oHVPUPVJl0ZpDY1HEwwLYPjBYz6gTCZLhboXo4o/Hu+MVk6P/YBlFU68lEKOb2LtVZtfuK
	1T1BYVA7J2UPAQbXHqgDADHXwec2Ux3svKkuNXYunQm5yWMGHUfqppTFiEy4q3xG3bi75x
	nY5gMjQYJwxCom31nCLPXTE6x6z9Lz8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 450752F9D;
	Thu,  9 Apr 2026 06:04:21 -0700 (PDT)
Received: from [10.164.148.43] (unknown [10.164.148.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66B673F641;
	Thu,  9 Apr 2026 06:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775739867; bh=edxyJPIpDcrkfXUhyUoWo4ZmUknvNS6KHcMk8cn0t/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WEWHru9Mm8PVscGfg0HS2jjbC3uPW/84RjXSA79iGQDftHDSidtj4+Za4wgmICpZ8
	 YgeyOYc20NhpLSo8TPZdbrMHyvxKRzDm5PQ80YA6AsBTkD9sJPqHOFR3NQNDMr1THh
	 D5bgeFoJdi/FmHS8Zyz8SYKked/kVDY6P4nMrIt4=
Message-ID: <00f8f77c-c9b2-4900-ba9b-52d6fe2332bd@arm.com>
Date: Thu, 9 Apr 2026 18:34:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260409014323.2385982-1-ye.liu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260409014323.2385982-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 38D7040017
X-Stat-Signature: bkgn61i51f4t1xzxnfgsc9q8ya3zipa9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775739868-342719
X-HE-Meta: U2FsdGVkX19CPE5LMuSx9BiWjFrlf/XJlL2zeY3hWjroeOs5a8P3DUc+wvsud1IjdXrzFgcx408QNk9kotjM719/OdvyZQQhFonst8whpPMkdF5CY7v0ViOwqEG8jvblTg0D0qXE+P+y8XtZb72iQdWtlj+QLYt9x3XYSt55AC1/UCzQ6KGuvn4wVM3qEWEj7ZE2mOCHQVMpaWC3xmENKZuvAagwgr0OpudeLzMbNnbK8qPgUODDV66a9ekaIBt0IEsZouuMGRDrVihaXEJhXqPdtWMDuYVUlBMucLzLq2aXze4JcZQddHulF4/5u2zY+naBADmKmmTOAzF5CV/NeItrNKabLnt2Ulf6ChP8aT2pdTF5+p5Z6iapcdYAjksheK6VaxHC0b5hiYGg4rA0jy46PaBB/AFtT9Fl/g9jfdvq5FroTfSVLU3rlgh9V7SfHhW4Qgfw/D/oIFulq6CFkVmP3TuLLRmjPdwW5FKwbv3ni1t3s0DZnVU8udoVUdSIitXYcjJvZL7FL+t3vSvEeXvzvj016rvsR+LvmKT/Ubd/8/sBX2o5tj121lRfqL2hwuEXn+Gj72jO121VBJvhuJrPEaPWZK5LcKB4q48VJ+qaoY6GrasZYaFWSdjE4oWKosI/YZOu2myKzdvz1JBi5QiOtN0jzeejwYIT4oOdQkesr/DMIkJ5ecT8QvxsbfpLV1juWzxyUGZoCa8l1Cc2gPngMrS6j3RQfL3tLkFkWxsUeVXymYgZs+Mk7obGumbxdoVDcWUnutROCIcRtAz/Pn1OyFajsDxVKfPOPznqQqE3HirfA6cu4zJcimJ3AXQF1SRB2RJCae7YeMvMGH+zDhi0MpO/bKsjcRDB0emoBH0i5UDLsu0AGZSHLlRJigEidrjpROUI5FsJpOm/L1b9H/LM3c34ROaNtaWc3S/KC7HYa4gTn+XhbUrObCLyrmj6SbEGohgL4itWEPb8iMH
 vQZ64LL2
 MgOdTtJbe+df2HAy8LkdJtyvnNTLd9DF2ChVJQE06c1OvV1QVfBEgQ3+/s6KQHRpv0hvbpyQsux6mjTkythhlaWicvNiPmuLgOiueOcoRiSRtM6BO4GhrY13FjHb9Y5vgtWWztdsKxUIZgzcLJTycQXH2f7wCEHRnV6UcDRkUvhoZCdNni6FVN6AmjXAsWOrLfddBy3y5OPNnPFWRz8G+43mjxZDpLBBVGLT5RwCKMJD1H9H7uliyb/qm2GCr0G2ZXPfD3BBLL5L7l2YXOEBr/Ep3sEZo8kP2pABiQBMc91ZsvVTvciBh+vnkQPh4jJM68qVj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/04/26 7:13 am, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> PMD alignment in khugepaged is currently implemented using a mix of
> rounding helpers and open-coded bitmask operations.
> 
> Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
> alignment, matching the preferred style for address and size handling.
> 
> No functional change intended.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> 
> Changes in v2:
> - Switch to ALIGN()/ALIGN_DOWN() per David's suggestion.
> - Also convert collapse_scan_mm_slot() to keep PMD alignment helpers
>   consistent within khugepaged.
> - Update the changelog accordingly.
> - Link to v1:https://lore.kernel.org/all/20260408093534.2373007-1-ye.liu@linux.dev/
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>



