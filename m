Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC00CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC9E6B02C7; Mon,  1 Jun 2026 04:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83CD6B02C9; Mon,  1 Jun 2026 04:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0E46B02CA; Mon,  1 Jun 2026 04:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA0656B02C7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:36:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75232A05EF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:36:35 +0000 (UTC)
X-FDA: 84830687550.11.2B27D17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D5F7D20004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:36:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Awl2Qklw;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780302993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CX5wVcPdVJkxD/ZKWZzIB+4vPMQ2papSJP/qE9C6oOw=;
	b=MVvLmyLJQqOyQEefBC3YsfQPYJNRZ1SGyyXeNhrD++w+fsh4fZlND94qRxFZZHnGp/9Wc+
	WElgFgfeJILnQw5CZIiz20zel4DE3loGfF52sYeaf9pcRAEOssLgFO2cudQVBroC1jo8W3
	LkoDnj33xI2JeHOg4IupGyV9uBFUfsk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Awl2Qklw;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780302993; a=rsa-sha256;
	cv=none;
	b=aEbsYK8PHmBkgW2pSKtPr1i+QTep7FLdYbMMw74Dw14RJmax2kqVKZyyPNPBhEjyH/Yup/
	uOx9aO/knOS6lbRECQ5ii4ERfEWByxW6QWOzF1h6Olf789lZn+jj0uT0pCcywKk9wZy1/Y
	9vdwL2AzdEJoyaZhOQ5dCZ9CpvFA068=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C35760098;
	Mon,  1 Jun 2026 08:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257101F00893;
	Mon,  1 Jun 2026 08:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780302993;
	bh=CX5wVcPdVJkxD/ZKWZzIB+4vPMQ2papSJP/qE9C6oOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Awl2QklwSbEIG3Ymmd/OBdnI2yrmd9PK72eTuZp3LX9nHwhVMIzRzLGFQk6SZ1o2S
	 ncZ3w9g4e2iUbkhDsSSkC3ALcDImuEI+dTTHJiQ21HFQ5JOaKtp/167LjQSweZrhXt
	 UYrjXTkkR6ZddsE3MksHgsRv+AyJaPky0bR5MG7NrjVIrWDCyj/KOSmG3ipFJasuHg
	 zXjPhmaxA13c4/fa5npvcWvQvK3Y5inlaUNG6iv9SzD2AJzY4QMABYBi2qLdT3xt96
	 f8+vJvJ4yVZnu5Q+5NTA/ehtvPidzGijaJURJI7eSKw5rVl88J8pWiygMLPMcX4EpZ
	 GNpxzWpy33NMQ==
Date: Mon, 1 Jun 2026 09:36:25 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, jgg@ziepe.ca, 
	leon@kernel.org, david@kernel.org, shuah@kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, balbirs@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-kselftest@vger.kernel.org, 
	usama.arif@linux.dev, ryan.roberts@arm.com, anshuman.khandual@arm.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] fs/proc/task_mmu: do not warn on seeing
 non-migration pmd entry
Message-ID: <ah1EZHWhO077k7tG@lucifer>
References: <20260530085413.1270139-1-dev.jain@arm.com>
 <20260530085413.1270139-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530085413.1270139-2-dev.jain@arm.com>
X-Stat-Signature: o3cas9sa7fj97pig9iwem6n675c5wsxr
X-Rspamd-Queue-Id: D5F7D20004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780302993-168506
X-HE-Meta: U2FsdGVkX18QOYqEaXTqdHDEXQx37WdbM1AQTJw27vCV4TY4oqf0y0kFcZuVQwoml3qcvjAGtBM2cQ1WxaB6j08Q0Kdzhwus8anBP5XoiJgdQcRXRNjncC3ZeqECf4cB7B2aR2oglAHMTYzYB8BOEweKgr2rLMOnjZ/1iOWall0wEWwf1sUZjwFtYJwCds1n9YrTxmw9ZXaAP3AFvmxg1cOnA0EXL+MxwievN0JeEnvTyVm7/wR3l5MI47pPza4gR+d3Qz8dbYvRLoC/1tPTFmoEnzJRuuoB1n4QR5eYqz4A379YwX3KQan2eNwSS6BnFAWgyspuwOLk0W/UuuR1ic3Xe8yp2It4MynP1DHeU0JnnMLPhMxREE0/oi/q/udFLBvW8Vp3BnFqfM/sbsViQFy9eYoE06paUhiY/q2X8MSyyJrTseEUU/d0NaVMmj+qPsPJfov+j3LFMOFZx+LAFOewQjovUy9m5N5SdfYNOP8eUXbBA7dkQdf8a9ybrFTQCAivcRNE2Umakji/4Dz6YwnGBxP8i0DdNbNMqcXlRJD/pmsWJ+HogigX0RxiQJpGIkT3eTxSsoD1cRqknezWV26eWM9e9/ZOelOrmEXx+3g9fM8D1WolcciRWi2ebhHwmzWAUV70HY2rU7gn1ebnzCF/fLeuKpWI7L6amVr/p6NpfJhCEh0KMNltRtnGWszfdyD11JM5LidkXaIXuC1ZVjWdybdKlU+N0vOvXZcZSW+vITOGHTPxEbX7Sb1FgTDiWVnDWbs90wWrV+MnCHO2ig2XiLN8xji6ud367L3EbMNGPV3BUfrNVRnCKgA2I4eS04NLTs/bFa2bbwQpFqS7BuILAXHuZILkAfmK8Bvln4y4OOFZnTNxJIl3Da4S9ssKfLrfnjbfjGPbARtjN9ybjEC2ikPmOvzdG6aQVkO4RpVNBg25/7gjVuhIFomLftHX8mJ2yG+bXw//HNC3j6f
 /3OpUiqp
 xQFiVOj/Ii+ZR/SWNCU2v/3+oX3Pm2uu+L7bP1KLwfZBUZZHpXcQCdK3L/vOWCztpSaPgMaA+1K62JnsfIXhxkM9VCH2j/KDr4OuEDEGKkGLJ0kI0jAbULWc+C8ed2X+agCVRGbW3FkWjzqJn37fMuIN5wwJF+ko9iTb1a8Ac57+NYuiYyQM927YaRdPNf0QwQvDv5iY+P+5bd9eoDJbG0/gxmvzyr2Id+daqREtUhU2HLlm+tqhcLqXv0FoHc4Y3+e4rap+d2VS+qzDNevNped8caI5sERhcNlHL9BKBTBHpV9/SdFzzHubkypKJ18qta72kMlMX3F+/7cLczILdJ1W4jVvY5bq5rhGm1U4NnKqI8QFFyBfHNfN37GEfdbqdjAjE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 08:54:11AM +0000, Dev Jain wrote:
> pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
> entry. This became false once device-private entries at the PMD level were
> added.
>
> Therefore, remove the stale migration-only assertion.
>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

I also verified that I could trigger this locally with your test, so feel free
to add:

Tested-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  fs/proc/task_mmu.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 1e3a15bf46f4e..58938e62154d9 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>  			flags |= PM_SOFT_DIRTY;
>  		if (pmd_swp_uffd_wp(pmd))
>  			flags |= PM_UFFD_WP;
> -		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
>  		page = softleaf_to_page(entry);
>  	}
>
> --
> 2.43.0
>

