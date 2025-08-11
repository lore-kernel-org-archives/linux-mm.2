Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14902C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 04:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9774E6B00E4; Mon, 11 Aug 2025 00:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928796B00E5; Mon, 11 Aug 2025 00:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8651B6B00E6; Mon, 11 Aug 2025 00:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76EA26B00E4
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:30:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D9F11A05D4
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:30:49 +0000 (UTC)
X-FDA: 83763201018.21.30E9D52
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16FC5C0005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:30:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754886647; a=rsa-sha256;
	cv=none;
	b=AoxhPfSy+Gp0DYfoXPANK2DoOyzb0ve4Dfx0vHPrzlDVKPbDuOG4cLP82sIhOZXhpdFi59
	YuK7WZ8EDgdqdfINqb1TtzAOC8t8M9lJAfgih8IopmWtwI8et6t4AdLnVYh3D9wW5BHO5v
	TZ68zL4ULZ5hC1CpnPCW/JVPtthG4Bs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754886647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m15gzroEbAXR3x36rb1zzxajxa7shxO60kZkG+X08iU=;
	b=ofp+b2tppX+u5/iT0hBS1KEFGn5etEkf9N936l0nPG4aiqfb1X7BjvFWDqMQeo+bDdD+5Q
	g+sOQJ47gB1zT7iggJ7ZYHVicFTmFyF6iPUBl/nr/CIpuJknpAXhwdNHd2xcOPC3mB1DRy
	sSzuhGhEP9N3ZOTZSB+ORbM9qw8XmSU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1630152B;
	Sun, 10 Aug 2025 21:30:37 -0700 (PDT)
Received: from [10.164.146.16] (J09HK2D2RT.blr.arm.com [10.164.146.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 695A93F738;
	Sun, 10 Aug 2025 21:30:42 -0700 (PDT)
Message-ID: <b33b6dfe-8270-4cee-bd66-1940f86b6e09@arm.com>
Date: Mon, 11 Aug 2025 10:00:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove unnecessary pointer variables
To: Xichao Zhao <zhao.xichao@vivo.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250811034257.154862-1-zhao.xichao@vivo.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250811034257.154862-1-zhao.xichao@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 16FC5C0005
X-Stat-Signature: autsk5bqsogodbq6xuwgf5733gfmz5s6
X-Rspam-User: 
X-HE-Tag: 1754886646-419113
X-HE-Meta: U2FsdGVkX1887XZCb4pp6OkRSbZZKd28Q4eVKR2E76N3sBiGSTd0XHwLKFaSyW6P/rAlYzY+MIUNJ9afhl3KEsotuBAtm6HA042kAiY/kWiL2Iev833acBkjMBUlck5u8c3S4PGdzfo+Qly7V86c5BpwfN2JyNukGC2Kb8OPv745j0pNWo31UVrKjcJDqx/L/53E74pHKVk5BHSJobgFO2xvCMqVfsLtzLSlqXcRIxjmiCmX+C+dMkt3rgh0HGh1pwCB+JZwDGdoAod0a7HQ0kIhWekXGhqoagrSvyeoSznb+ZGANnhnASaKeFCtzkCRfF4/+Qd5/s3aAKmXMo2UFXDHL7ct82LDThoz9OakjSIY8qskSWKYHFdHJ4hNsiDluexkzc8zoOYHYkOhrAk94D+/rIqYZuTMBRYV331uvLa2lZg052HLq4VWEmPcRo39Bfd1PD3/k3C9+7FGdLJPMSAmcyV/Uh4nBkdNVJNqRFiqlygEUjmfbkUBYqS2uZ22nQtycJ4NrGnAhwxx/Uv6R94ITlz2M8W3pqP3Zjsw7wwiAP4TSrenEmh12A2pYs/lSJqvOAV6P3y4Uf1O3gvovfmVkS0lx1Xgy194Is7Bl02AjgtVZcatMRURAQjbr25Ar1X6Yl9EnggBzJ6ZtjRCW4qznbpzdxGxRXLo6zfeWgsFuiwhtqoGyBFISZ+ARyo8r6Rug+GEcuHgUnc9fePUfeE8m0tIKxdXlQIfafTkPg1t71nU9MIYF7xV7PHmnyhQMD4ij+ooOa4idh5DSjCyorNBHbuHn3oceNtnacB/FN29zuCU3tMSeN94aX6aCp76gWsE5hAv88rBNiflWIVZnvsVf0QBd6UZ1ZrfiZUJ3c18i9ybDrwrief+wq6QP4WchIcPJqL41MhLW8q7iY4Nnx121/rqdUB5UajIDMpeobsQ4kAgGwuJNKzSqbbAFxykPLbEPxA4p2YntwxX8T1
 qMPQlgdZ
 XYV/y/wprAwqSQUXCkdcSaIHUm9pqtSsxUhwS2tCxSnOgUivVK3thwxordDHnmcZqT2gVP1FFLsmQ7J9FfFwvoFVsdufxd4lZ9b/YxuhSDd2NVr2qODZUvShBT6DxUe8Ws7hRSpNHKhN/FjB+e3j9C/29rK88DBtnzWl+zLgDmGgu8WQi/BiEQ8xjs8zFghvhDiCyb+JfmiV5iD34fUQGrgAN5BOtRSgKoiSOeCxXB8KL1CEO6q/dmemIC4g+2jUFmpK/mkKJ71Bx1ZfFUPrQRi51JzpjPU6FHqAOyr8wxTe3ydaTVi0zoTzzHwA2f7eIEQgUYbS+tohm0Jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/08/25 9:12 AM, Xichao Zhao wrote:
> Simplify the code to enhance readability and maintain a consistent
> coding style.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>  mm/kasan/init.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> index ced6b29fcf76..e5810134813c 100644
> --- a/mm/kasan/init.c
> +++ b/mm/kasan/init.c
> @@ -266,11 +266,9 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
>  		}
>  
>  		if (pgd_none(*pgd)) {
> -			p4d_t *p;
>  
>  			if (slab_is_available()) {
> -				p = p4d_alloc(&init_mm, pgd, addr);
> -				if (!p)
> +				if (!p4d_alloc(&init_mm, pgd, addr))
>  					return -ENOMEM;
>  			} else {
>  				pgd_populate(&init_mm, pgd,

Agreed that p4d_t pointer here is just redundant.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

