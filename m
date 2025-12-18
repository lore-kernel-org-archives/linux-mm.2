Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F91D6ACE8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F010F6B0089; Thu, 18 Dec 2025 06:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEBA16B008A; Thu, 18 Dec 2025 06:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACBD6B008C; Thu, 18 Dec 2025 06:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA99D6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:23:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7799B61107
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:23:46 +0000 (UTC)
X-FDA: 84232356852.14.92C69FC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id D9860C0008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:23:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C5NWFJMC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mPssw+wb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C5NWFJMC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mPssw+wb;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766057024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkIK+I4PFuj77KSv9EJaFoX/yib3F48+Q2EoloLTPSk=;
	b=DKMQjH3StiSIWDrbHiUd3B6kCtvsJpbcFwa7Drxx7lbHiM6o9yhJ+Cph/HH9ZRrNB9CSnC
	3UTyJ5zTE6EuciucfIq/UTOMz4btRQ+WWUD/W27CD+I8C9GWqgatcGEyOoxGZBXnCDx3TA
	MFVutwnI6zRKYTMelz+o+tA2WYBEqs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766057024; a=rsa-sha256;
	cv=none;
	b=13k3u+s4zGdxrhdPGulqjK6WVn523R4OFR+0FFeIL6S/gMMuw9I+cbeXHtHYQdssOaWso9
	o3GmXiOaPnuAvTSfS9OuPG0QlqF7UpuRsv0xwPd4Mw0wtYlgMznzBQ3pKgzfu1VZxbjiNi
	HjLplZnxiog9EdkHyiROhkJpM0RI0EI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C5NWFJMC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mPssw+wb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C5NWFJMC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mPssw+wb;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 46B085BE40;
	Thu, 18 Dec 2025 11:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766057022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YkIK+I4PFuj77KSv9EJaFoX/yib3F48+Q2EoloLTPSk=;
	b=C5NWFJMCNVlymy57XJC2XqlCJPE0uuXRDl9PlVAkHEekrqy6bnoomHmAN4sdO7w9xCzMSj
	yrc2L4R/koGf2YiYkvkHqTy7nw5Z+iPRL818F9C0DlOlLUMP/+ogazsdyyRcr6LzXUSdvN
	c7eC4D9QyvJw72HE/4TS+LG/XrtDFvg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766057022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YkIK+I4PFuj77KSv9EJaFoX/yib3F48+Q2EoloLTPSk=;
	b=mPssw+wbMaXNRuVAdqBMGvphXtFfDkh4JCgbSX2V4lLEQ/Dz/DmVP4jlOQUTdyi69FQQhc
	mcHDgwbnzdaG1GBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766057022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YkIK+I4PFuj77KSv9EJaFoX/yib3F48+Q2EoloLTPSk=;
	b=C5NWFJMCNVlymy57XJC2XqlCJPE0uuXRDl9PlVAkHEekrqy6bnoomHmAN4sdO7w9xCzMSj
	yrc2L4R/koGf2YiYkvkHqTy7nw5Z+iPRL818F9C0DlOlLUMP/+ogazsdyyRcr6LzXUSdvN
	c7eC4D9QyvJw72HE/4TS+LG/XrtDFvg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766057022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YkIK+I4PFuj77KSv9EJaFoX/yib3F48+Q2EoloLTPSk=;
	b=mPssw+wbMaXNRuVAdqBMGvphXtFfDkh4JCgbSX2V4lLEQ/Dz/DmVP4jlOQUTdyi69FQQhc
	mcHDgwbnzdaG1GBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F34B53EA63;
	Thu, 18 Dec 2025 11:23:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GeYNOz3kQ2k+ZQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 18 Dec 2025 11:23:41 +0000
Message-ID: <aeff83f2-a97b-41ac-8d19-8536f88b154b@suse.cz>
Date: Thu, 18 Dec 2025 12:23:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: Report 1 as zone_batchsize for
 !CONFIG_MMU
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>, Guenter Roeck <linux@roeck-us.net>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tjiw8preqoos3npso84tsbwa6seoeapu
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9860C0008
X-Rspam-User: 
X-HE-Tag: 1766057023-418152
X-HE-Meta: U2FsdGVkX18fvIsNgN0M5mL9rqDibHfNMRy+NhWHeZHkP6B303ZDmixtw6JW0AWPKUHqCrdAKlkxHpumjsLaTWV6nctOA6PFj8g+lVdzXd8gETTpEY0TkZklwVSBS/zjMZ3S1xUu2XLj/PrQqFFPIfzviZbrzU19+JOD/BrR3Yo/KHskIbIaemoUuw+q5AmvDjLbzzXl8TX8m9kO/S4R6LVJnrEXc1TSUHI6Pe6AP3ajC1iTrG+Iyd8eutKq9+2MD7cg1EF7tkWURdy35e+YKwSt+5wk4N48Xj5kzTIi3VLXz6mLaQ5ItJuFSnUtSaUGUmm8Nxegy2GKM+2XFI1RyjSHb3i40r3cWSaRuuLZ4Bu7iiy+FP+fkb/dcV7Z5KYdyMwXyrPtFSWyiaw3wRxJZ53wOxeMNNHc7/Px8uKrcUhcis1lG0S4IdyT86X7PmEdZn6xi79X9vNW3kixkGja0PcZFEuw3uUU8PIeKxfYUucJzqX4gyNnFRXtte33oHCjdio2VxdOqXaOxAQHOT+vpuxa8TUfxIPoGQWayiBRUKHhJbOZYh+XKznLxIW/Ruxag43gRFs/F78S9c3MzF5lA3//NtDvBxh7YYRyzj9mAhEM/JRphqBX3TGxaGCfLl/J8/6kMwF2t/IJ5AZa9+VW9iCacYor/lQ786mQT2h8ttGtaXR8QrOtlT+CRmcVbotEe1BruRxAgp82wTdZvOELK7miH/nAUBtgvjVIWvtM/wUbBAhBqf+TOHbCFh++U52aVsfOrWwSN19Grel/RVX4DOqlKPT939FKJ7xaaydhbrz9up0qNkHAHCJ1BA0nT9+ikM470mB9vMf+FH7vruz5vj1IHhgxPCd/dcjwk66ukOLvfspLf0BackO8drpluKz9xrA/LfWJvrYAdtSRMdGm2eMhjioC7Ygm9H6wdEcr6AN8Chmogh3Q4+C27UIfF+RZzZK9RMYw111W+Lxb0Ep
 v4xChGQP
 qQ/muBcauwLbQUgaSV/SKIZsq+6akkg4OanW2QxQrBxoao7skYovcp/Z0j3WO4/s8vOLnMCdU61w3A6h4YZhsISvYk9hDS6Xloi+vtUguJpvhsMxerokUGAiHEonlxcyAfojFpO3FWA80FYP7ysHFrPynz7X4w2CPE5RZpwfgRbIsCaUXQRyb22bL6SGiBhPtKspMVB0u/ZkSk5dl4rfHCSpCAI8hYKMGIipzqwXjU2dm8HUshtscVPWmPSwtaNEthB2pIFuoaNG10+j5AjX4ceDPIwy3ptvLnkF1UMHqBP1jVzqTPqBu5PyviHYHrW8m1jmzRbmZQkkNK5yOemeoFVI1RpwrFGKQYWmri6cm+PtVulEMbFCM5WPKRWJKpHiduUrPkEtl2MFr68FcHm7aBILomvjyd73T7cokopuTqr95CD0/IklDcrAK+fIyIJjlo6SojdY2VwB8tio5c/+XB8KPjLb3IziajfDOEOyUUCPrFWEKHcKu6zs4fateqUpupp99cejb+Fy+9/8z7nFGrHoswhqO2aUs/gT2HWzk7QE1T3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 09:31, Joshua Hahn wrote:
> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> moved the error handling (0-handling) of zone_batchsize from its
> callers to inside the function. However, the commit left out the error
> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> 
> For NOMMU systems, return 1 instead of 0 for zone_batchsize, which restores
> the previous deadlock-free behavior.
> 
> There is no functional difference expected with this patch before commit
> 2783088ef24e, other than the pr_debug in zone_pcp_init now printing out
> 1 instead of 0 for zones in NOMMU systems. Not only is this a pr_debug,
> the difference is purely semantic anyways.
> 
> Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> Reported-by: Daniel Palmer <daniel@thingy.jp>
> Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> v1 --> v2:
> - Instead of restoring  max(1, zone_batchsize(zone)), just return 1 for NOMMU
>   systems since this is simpler and only affects a single pr_debug.
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..977cbf20777d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5924,7 +5924,7 @@ static int zone_batchsize(struct zone *zone)
>  	 * recycled, this leads to the once large chunks of space being
>  	 * fragmented and becoming unavailable for high-order allocations.
>  	 */
> -	return 0;
> +	return 1;
>  #endif
>  }
>  
> 
> base-commit: 40fbbd64bba6c6e7a72885d2f59b6a3be9991eeb


