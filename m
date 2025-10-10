Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4522FCCD18D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 05:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A168E0003; Fri, 10 Oct 2025 01:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24AC38E0002; Fri, 10 Oct 2025 01:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178048E0003; Fri, 10 Oct 2025 01:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03DDE8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:46:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FAE6160189
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 05:46:37 +0000 (UTC)
X-FDA: 83981120034.10.3627550
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6605640008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 05:46:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760075195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVkjKocsgpXxosK6jJVJ+/n4lsJFkOvqwhN8FluemF0=;
	b=fNo1pXYZfM53USfKbPI9rm6l3y9NdNyEPvYC9+XwqYzUN87FT6mn/ip7h7agbyvDxO3glm
	GTsgPH/C4ZtBv89tvYTFMbGgQ/t/tAMfQxZpdpeOgbQChovDZVxXmiLT32I1GydMKx2Nrt
	3cZ0hRrvsorICGXQ6OonEgQ6xkinL+U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760075195; a=rsa-sha256;
	cv=none;
	b=sumeYMVLYC32ugS5IT2e/jqm5dYIr5TQ3SwHkMUv7q0pMlyuYBD+/WYuOMkwM47G0OpbC/
	Si1FgRe8TRJLN4WGhCfr/RTnEcufiX7TuPnz6k5qipKUTwFub+lyOIXEatCV94d0K5FjWW
	BfPGspwVv2VJDsKdJkWqh/sJpOtfL10=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E0881596;
	Thu,  9 Oct 2025 22:46:26 -0700 (PDT)
Received: from [10.163.67.91] (unknown [10.163.67.91])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3D533F738;
	Thu,  9 Oct 2025 22:46:31 -0700 (PDT)
Message-ID: <13c257c7-1ff8-43b4-825b-03a3ceb32e96@arm.com>
Date: Fri, 10 Oct 2025 11:16:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE
 aligned
To: Yadong Qi <yadong.qi@linux.alibaba.com>, akpm@linux-foundation.org,
 urezki@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ying.huang@linux.alibaba.com
References: <20251010014311.1689-1-yadong.qi@linux.alibaba.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251010014311.1689-1-yadong.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6605640008
X-Stat-Signature: 15zrj43yb7t5oqtgbwtmkpquik9c3a5r
X-Rspam-User: 
X-HE-Tag: 1760075195-202592
X-HE-Meta: U2FsdGVkX1+ZfcHGfK+9aJ8qOC2wKdnL28AdYy2TF//HUIdq0v7uLLMN2ioN2FA5zKXw+tA0WCx4bekNg0jJil6xafxd876MmcbtSRdzczUM6E0RbtDaY7exKzuuAnkmpPhbAARuQCcCcNAMkKZZQnjZEqxaHDCYpjypxOxGRWFP+lSk/66XUnHjGB7QaNzrEz6/EdSRhs2Ctzr3Wa+P80S32cXiVikEnI0gVY0e92xDyH6dSPo/fihXLj2q9vgZ23nyaZu5cCFXnq6bIBph/LPb3HX5Kfk8x/Hcp3kIx68NAP4oWDrv9EHKOS/kd7S+7zzh31uHe4olakJ4bqQeS3OACsdgYr3cwImBS/Liq/em66oLzdUO1n97BLv6KhqK+DV27+YjouqRy4itx2CwvLsd5HxwxLc/Cu2X2ECEGOFkplb/p3QcZ8PnVY3gIoHbn6p6CsuUnTy2v+0iDDJo+iIWIg+9tda4kzFgActEWD25MmyZKSqXMwcd1c6tIs5SCPMrRNiIi7GFOU7Bl66rPrxKfB2SUuk4s7nUq+i4EjZofspT9fg19dvmzIR2GHuDOsqGREDVUp9dr1qR6mBnWiHutIvm/T3oojY6EM2hhHRbUc9mrlrxCLhF6mVahaDZNY8q45LDSWikkLCubWkw2i8sJT14CfRHN8xIccAbzqtdEaBMMiZXwV1YhpWZDZFqawgqngeNXHI8BWuHRE5QAo3/SasQXD789rmmhnXDYIM70jony0yGKIMDLk/bnHQRIVHrFY/1wIi46HP/VTnefMHAbXhPxLpJav0Or0BArhWcxmb17IPy+uzRC44uJUH4bvsX0ahQCEuS+ppR0CE47NhDCekgMkM2cPKt5ZYam8FlWZ8PoE80lfSOmEEz1Pvs/mKGC+fWVIga/ArA9RsxvAdDn1yemVLrbzN9ZQHE6yYN1UFtXDbd54sMxPhQqJwSsryJnvBhExB03cRmzJy
 g6byNm53
 Vf0OxLCK2fekE9oPLiohD/9NegNVVdkcSp78hwZSm3NbLjFxfJ/33mutu+dRLCQuDi24ilfSKpxyb6e/77FgXRlw3/uHeF5na87LX6gZmG8/h3DqgVAAVz1lYqO+tIKemAtoVeE8gEMEPqTcQorAo4OhFi5prhI7mdndRbSVoOFZC5Gq6uXfx3lXGN6n168qzxEU6sSHx/Vz/ZHfE3SXHRqp9cRYAyZ1zRGyFbFyIjzmsDvlGwKJLS5YlxI4XGqsQmOIRsm7EsjtGbpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/10/25 7:13 am, Yadong Qi wrote:
> In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> mapping size is aligned to PAGE_SIZE. If this assumption is
> violated, the loop will become infinite because the termination
> condition (`addr != end`) will never be met. This can lead to
> overwriting other VA ranges and/or random pages physically follow
> the page table.
>
> It's the caller's responsibility to ensure that the mapping size
> is aligned to PAGE_SIZE. However, the memory corruption is hard
> to root cause. To identify the programming error in the caller
> easier, check whether the mapping size is PAGE_SIZE aligned with
> WARN_ON_ONCE().
>
> Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> ---

This should work.

Reviewed-by: Dev Jain <dev.jain@arm.com>


